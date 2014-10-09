//
//  HeatMapView.m
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import "HeatMapView.h"

@interface HeatMapView ()

- (void)drawSquareKey:(CGRect)rect keyCode:(int)code;

@end

@implementation HeatMapView

- (BOOL)isFlipped {
  return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];
  
  CGFloat squareKeySize = MIN(self.frame.size.height / 3.0,
                              self.frame.size.width / 12.0);
  
  NSArray * topRow = @[@(12), @(13), @(14), @(15), @(17), @(16), @(32), @(34),
                       @(31), @(35), @(33), @(30)];
  NSArray * homeRow = @[@(0), @(1), @(2), @(3), @(5), @(4), @(38), @(40), @(37),
                        @(41)];
  NSArray * bottomRow = @[@(6), @(7), @(8), @(9), @(11), @(45), @(46), @(43),
                          @(47), @(44)];
  for (int i = 0; i < topRow.count; ++i) {
    [self drawSquareKey:CGRectMake((CGFloat)i * squareKeySize, 0.0,
                                   squareKeySize, squareKeySize)
                keyCode:[topRow[i] intValue]];
  }
  for (int i = 0; i < homeRow.count; ++i) {
    [self drawSquareKey:CGRectMake((CGFloat)i * squareKeySize, squareKeySize,
                                   squareKeySize, squareKeySize)
                keyCode:[homeRow[i] intValue]];
  }
  for (int i = 0; i < bottomRow.count; ++i) {
    [self drawSquareKey:CGRectMake((CGFloat)i * squareKeySize,
                                   squareKeySize * 2,
                                   squareKeySize, squareKeySize)
                keyCode:[bottomRow[i] intValue]];
  }
}

- (void)drawSquareKey:(CGRect)rect keyCode:(int)code {
  CGFloat maxCount = (CGFloat)[self.profile maximumCount];
  CGFloat thisCount = (CGFloat)[self.profile keyCountsForKey:code
                                                   modifiers:self.modifiers];
  CGFloat heat = maxCount == 0 ? 0 : thisCount / maxCount;
  NSBezierPath * circle = [NSBezierPath bezierPathWithRoundedRect:rect
      xRadius:rect.size.width / 2.0
      yRadius:rect.size.height / 2.0];
  [[NSColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:heat] set];
  [circle fill];
}

@end
