//
//  HeatMapKey.m
//  HeatKey
//
//  Created by Alex Nichol on 10/10/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import "HeatMapKey.h"

@implementation HeatMapKey

- (id)initWithShorthand:(NSString *)str {
  if ((self = [super init])) {
    if ([str hasPrefix:@"_"]) {
      self.visible = NO;
      str = [str substringFromIndex:1];
    } else {
      self.visible = YES;
    }
    self.type = (char)[str characterAtIndex:0];
    if (str.length == 1) {
      self.ignoreValue = YES;
    } else {
      self.ignoreValue = NO;
      self.keyCode = [[str substringFromIndex:1] intValue];
    }
  }
  return self;
}

- (CGFloat)widthForSpaceSize:(CGFloat)spaceSize {
  NSDictionary * widths = @{@('F'): @(5),
                            @('R'): @(14.0/3.0),
                            @('D'): @(28.0/3.0),
                            @('T'): @(28.0/3.0),
                            @('C'): @(59.0/6.0),
                            @('E'): @(59.0/6.0),
                            @('S'): @(38.0/3.0),
                            @('P'): @((4 + (5 * 14.0/3.0)))};
  return spaceSize * [widths[@(self.type)] doubleValue];
}

@end
