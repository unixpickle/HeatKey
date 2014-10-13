//
//  HeatMapView.m
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import "HeatMapView.h"

@interface HeatMapView ()

@property (readwrite) CGFloat maxCount;
@property (readwrite) NSTrackingArea * trackingArea;
@property (nonatomic, retain) NSTextField * countTextField;

- (void)drawKey:(HeatMapKey *)key;
- (void)recomputeMaxCount;

- (void)retrack;

@end

@implementation HeatMapView

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    self.mapLayout = [[HeatMapLayout alloc] init];
    self.countTextField = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [self.countTextField setBordered:NO];
    self.countTextField.font = [NSFont systemFontOfSize:15.0];
    self.countTextField.backgroundColor = [NSColor colorWithWhite:0.9 alpha:1];
    self.countTextField.wantsLayer = YES;
    self.countTextField.alignment = NSCenterTextAlignment;
    [self.countTextField setSelectable:NO];
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [NSColor blackColor];
    shadow.shadowBlurRadius = 2;
    shadow.shadowOffset = NSZeroSize;
    [self.countTextField setShadow:shadow];
  }
  return self;
}

- (BOOL)isFlipped {
  return YES;
}

- (void)viewDidMoveToWindow {
  [self retrack];
  [self.mapLayout performLayout:self.frame.size];
}

- (void)setFrame:(NSRect)frameRect {
  [super setFrame:frameRect];
  [self retrack];
  [self.mapLayout performLayout:self.frame.size];
}

- (void)setBounds:(NSRect)aRect {
  [super setBounds:aRect];
  [self retrack];
  [self.mapLayout performLayout:self.frame.size];
}

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];
  
  [self recomputeMaxCount];
  
  for (HeatMapKey * key in self.mapLayout.keys) {
    [self drawKey:key];
  }
}

- (void)drawKey:(HeatMapKey *)key {
  NSRect frame = key.frame;
  frame.origin.x -= 0.5;
  frame.origin.y -= 0.5;
  NSBezierPath * bezier = [NSBezierPath bezierPathWithRoundedRect:frame
                                                          xRadius:3.0
                                                          yRadius:3.0];
  if (key.visible && !key.ignoreValue) {
    unsigned long long count = [self.profile keyCountsForKey:key.keyCode
                                                   modifiers:self.modifiers];
    CGFloat heat = (CGFloat)count / self.maxCount;
    if (heat > 1.0) {
      // Should only occur in the case of a rounding error.
      heat = 1.0;
    }
    [[NSColor colorWithRed:1.0
                     green:(1.0 - heat)
                      blue:(1.0 - heat)
                     alpha:1.0] set];
    [bezier fill];
  } else if (key.visible) {
    [[NSColor grayColor] setFill];
    [bezier fill];
  }
  if (key.visible) {
    [[NSColor blackColor] setStroke];
    [bezier stroke];
  }
}

- (void)recomputeMaxCount {
  NSIndexSet * keys = [self.mapLayout visibleKeyCodes];
  int mods = self.modifiers;
  unsigned long long maxCount = [self.profile maximumCountsForKeys:keys
                                                         modifiers:mods];
  self.maxCount = (CGFloat)MAX(maxCount, 1);
}

#pragma mark - Mouse Events -

- (void)retrack {
  if (self.trackingArea) {
    [self removeTrackingArea:self.trackingArea];
  }
  NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited |
                                  NSTrackingMouseMoved |
                                  NSTrackingActiveInKeyWindow;
  self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                   options:options
                                                     owner:self
                                                  userInfo:nil];
  [self addTrackingArea:self.trackingArea];
}

- (void)mouseMoved:(NSEvent *)theEvent {
  NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
  HeatMapKey * key = [self.mapLayout keyAtPoint:point];
  if (key.ignoreValue || !key.visible) {
    if (self.countTextField.superview) {
      [self.countTextField removeFromSuperview];
    }
    return;
  }
  unsigned long long count = [self.profile keyCountsForKey:key.keyCode
                                                 modifiers:self.modifiers];
  self.countTextField.stringValue = [NSString stringWithFormat:@"%llu", count];
  [self.countTextField sizeToFit];
  
  NSRect frame = self.countTextField.frame;
  frame.size.width += 10;
  if (point.x < self.frame.size.width / 2) {
    frame.origin.x = point.x + 5;
  } else {
    frame.origin.x = point.x - frame.size.width - 5;
  }
  frame.origin.y = point.y - 18;
  self.countTextField.frame = frame;
  
  if (!self.countTextField.superview) {
    [self addSubview:self.countTextField];
  }
}

- (void)mouseExited:(NSEvent *)theEvent {
  if (self.countTextField.superview) {
    [self.countTextField removeFromSuperview];
  }
}

@end
