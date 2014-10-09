//
//  HeatMapView.m
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import "HeatMapView.h"

@interface HeatMapView ()

@property (readwrite) CGFloat spaceSize;
@property (readwrite) CGFloat maxCount;

- (CGPoint)drawKey:(NSString *)representation point:(CGPoint)point;

@end

@implementation HeatMapView

- (BOOL)isFlipped {
  return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];
  
  const CGFloat spacesWide = 83.0;
  const CGFloat spacesTall = 29.0;
  NSString * layout = @"F53 F122 F120 F99 F118 F96 F97 F98 F100 F101 F109 F103"
      @" F111 F\n"
      @"R50 R18 R19 R20 R21 R23 R22 R26 R28 R25 R29 R27 R24 D51\n"
      @"T48 R12 R13 R14 R15 R17 R16 R32 R34 R31 R35 R33 R30 R42\n"
      @"C R0 R1 R2 R3 R5 R4 R38 R40 R37 R41 R39 E36\n"
      @"S R6 R7 R8 R9 R11 R45 R46 R43 R47 R44 S\n"
      @"_S _R _R P49 _R _R _R _S";
  
  self.maxCount = (CGFloat)([self.profile maximumCount:self.modifiers] ?: 1);
  CGPoint startPoint = CGPointZero;
  if (self.frame.size.width * (spacesTall / spacesWide) >
      self.frame.size.height) {
    // The view is too wide
    self.spaceSize = self.frame.size.height / spacesTall;
    startPoint.x = (self.frame.size.width - (self.spaceSize * spacesWide)) /
                   2.0;
  } else {
    // The view is too tall
    self.spaceSize = self.frame.size.width / 83.0;
    startPoint.y = (self.frame.size.height - (self.spaceSize * spacesTall)) /
                   2.0;
  }
  
  CGPoint point = startPoint;
  for (NSString * line in [layout componentsSeparatedByString:@"\n"]) {
    for (NSString * key in [line componentsSeparatedByString:@" "]) {
      point = [self drawKey:key point:point];
    }
    point.y += self.spaceSize * 5;
    point.x = startPoint.x;
  }
}

- (CGPoint)drawKey:(NSString *)representation point:(CGPoint)point {
  NSDictionary * widths = @{@"F": @(self.spaceSize * 5),
                            @"R": @(self.spaceSize * 14.0/3.0),
                            @"D": @(self.spaceSize * 28.0/3.0),
                            @"T": @(self.spaceSize * 28.0/3.0),
                            @"C": @(self.spaceSize * 59.0/6.0),
                            @"E": @(self.spaceSize * 59.0/6.0),
                            @"S": @(self.spaceSize * 38.0/3.0),
                            @"P": @(self.spaceSize * (4 + (5 * 14.0/3.0)))};
  BOOL hollow = NO;
  if ([representation hasPrefix:@"_"]) {
    representation = [representation substringFromIndex:1];
    hollow = YES;
  }
  CGFloat keyWidth = [widths[[representation substringToIndex:1]] floatValue];
  CGFloat keyHeight = self.spaceSize * 4;
  NSRect rect = NSMakeRect(point.x,
                           point.y,
                           keyWidth,
                           keyHeight);
  NSBezierPath * bezier = [NSBezierPath
                           bezierPathWithRoundedRect:rect
                                             xRadius:(self.spaceSize / 2.0)
                                             yRadius:(self.spaceSize / 2.0)];
  if (representation.length > 1) {
    int keyCode = [[representation substringFromIndex:1] intValue];
    unsigned long long count = [self.profile keyCountsForKey:keyCode
                                                   modifiers:self.modifiers];
    CGFloat heat = (CGFloat)count / self.maxCount;
    [[NSColor colorWithRed:1.0 green:(1.0 - heat) blue:(1.0 - heat) alpha:1.0]
     set];
    [[NSColor blackColor] setStroke];
    [bezier fill];
    [bezier stroke];
  } else if (!hollow) {
    [[NSColor grayColor] setFill];
    [bezier fill];
  }
  return CGPointMake(point.x + keyWidth + self.spaceSize, point.y);
}

@end
