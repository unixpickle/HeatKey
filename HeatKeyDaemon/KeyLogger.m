//
//  KeyLogger.m
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import "KeyLogger.h"
#import "Profile.h"

static CGEventRef _EventCallback(CGEventTapProxy proxy, CGEventType type,
                                 CGEventRef event, void * refcon);

@implementation KeyLogger

- (id)init {
  if ((self = [super init])) {
    [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                   selector:@selector(pingDelegate)
                                   userInfo:nil repeats:YES];
  }
  return self;
}

- (void)start {
  if (!eventTap) {
    eventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap,
                                kCGEventTapOptionDefault,
                                CGEventMaskBit(kCGEventKeyDown),
                                _EventCallback, (__bridge void *)self);
    if (!eventTap) {
      return;
    }
    runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault,
                                                  eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource,
                       kCFRunLoopCommonModes);
  }
  CGEventTapEnable(eventTap, true);
}

- (void)stop {
  if (!eventTap) {
    return;
  }
  CGEventTapEnable(eventTap, false);
}

- (void)kill {
  [self.connection invalidate];
  self.connection = nil;
  
  // Give the connection time to shutdown properly
  dispatch_async(dispatch_get_main_queue(), ^{
    exit(0);
  });
}

- (void)died:(NSNotification *)note {
  exit(0);
}

- (void)pingDelegate {
  [self.delegate ping];
}

- (void)dealloc {
  if (eventTap) {
    NSAssert(runLoopSource != NULL, @"Expected run loop source");
    CFRunLoopRemoveSource(CFRunLoopGetMain(), runLoopSource,
                          kCFRunLoopCommonModes);
    CFRelease(runLoopSource);
    CFRelease(eventTap);
  }
}

@end

static CGEventRef _EventCallback(CGEventTapProxy proxy, CGEventType type,
                                 CGEventRef event, void * refcon) {
  KeyLogger * logger = (__bridge KeyLogger *)refcon;
  if (logger.delegate) {
    CGEventFlags flags = CGEventGetFlags(event);
    BOOL shift = ((flags & kCGEventFlagMaskShift) != 0);
    BOOL command = ((flags & kCGEventFlagMaskCommand) != 0);
    BOOL option = ((flags & kCGEventFlagMaskAlternate) != 0);
    BOOL control = ((flags & kCGEventFlagMaskControl) != 0);
    int modifiers = [Profile modifiersMaskWithShift:shift command:command
                                             option:option control:control];
    int64_t value = CGEventGetIntegerValueField(event,
                                                kCGKeyboardEventKeycode);
    dispatch_async(dispatch_get_main_queue(), ^{
      [logger.delegate keyPressed:(int)value modifiers:modifiers];
    });
  }
  return event;
}
