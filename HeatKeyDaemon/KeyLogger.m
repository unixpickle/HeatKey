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

- (BOOL)beginLogging {
  if (!eventTap) {
    eventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap,
                                kCGEventTapOptionDefault,
                                CGEventMaskBit(kCGEventKeyDown),
                                _EventCallback, (__bridge void *)self);
    if (!eventTap) {
      return NO;
    }
    runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault,
                                                  eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource,
                       kCFRunLoopCommonModes);
  }
  CGEventTapEnable(eventTap, true);
  return YES;
}

- (void)stopLogging {
  if (!eventTap) {
    return;
  }
  CGEventTapEnable(eventTap, false);
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
  if (logger.callback) {
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
      logger.callback((int)value, modifiers);
    });
  }
  return event;
}
