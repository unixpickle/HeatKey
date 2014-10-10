//
//  HeatMapLayout.m
//  HeatKey
//
//  Created by Alex Nichol on 10/10/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import "HeatMapLayout.h"

@interface HeatMapLayout ()

@property (nonatomic, strong) NSArray * keys;
@property (nonatomic, strong) NSIndexSet * codesWithSpace;
@property (nonatomic, strong) NSIndexSet * codesWithoutSpace;
@property (readwrite) CGFloat spaceSize;

+ (NSString *)defaultLayout;

@end

@implementation HeatMapLayout

+ (NSString *)defaultLayout {
  return @"F53 F122 F120 F99 F118 F96 F97 F98 F100 F101 F109 F103 F111 F\n"
         @"R50 R18 R19 R20 R21 R23 R22 R26 R28 R25 R29 R27 R24 D51\n"
         @"T48 R12 R13 R14 R15 R17 R16 R32 R34 R31 R35 R33 R30 R42\n"
         @"C R0 R1 R2 R3 R5 R4 R38 R40 R37 R41 R39 E36\n"
         @"S R6 R7 R8 R9 R11 R45 R46 R43 R47 R44 S\n"
         @"_S _R _R P49 _R _R _R _S";
}

- (id)init {
  if ((self = [super init])) {
    NSMutableArray * keysList = [NSMutableArray array];
    NSMutableIndexSet * withSpace = [NSMutableIndexSet indexSet];
    NSString * layoutStr = [self.class defaultLayout];
    for (NSString * str in [layoutStr componentsSeparatedByString:@"\n"]) {
      for (NSString * keyStr in [str componentsSeparatedByString:@" "]) {
        HeatMapKey * key = [[HeatMapKey alloc] initWithShorthand:keyStr];
        [keysList addObject:key];
        [withSpace addIndex:(NSUInteger)key.keyCode];
      }
    }
    self.codesWithSpace = [withSpace copy];
    [withSpace removeIndex:(NSUInteger)49];
    self.codesWithoutSpace = [withSpace copy];
    self.keys = keysList;
    self.showSpaceBar = NO;
  }
  return self;
}

- (void)performLayout:(NSSize)_size {
  const CGFloat spacesWide = 83.0;
  const CGFloat spacesTall = 29.0;
  
  NSSize size = _size;
  size.width -= 2;
  size.height -= 2;
    
  CGPoint startPoint = CGPointMake(1, 1);
  if (size.width * (spacesTall / spacesWide) > size.height) {
    // The view is too wide
    self.spaceSize = size.height / spacesTall;
    startPoint.x = (_size.width - (self.spaceSize * spacesWide)) /
    2.0;
  } else {
    // The view is too tall
    self.spaceSize = size.width / 83.0;
    startPoint.y = (_size.height - (self.spaceSize * spacesTall)) /
    2.0;
  }
  
  NSString * layoutStr = [self.class defaultLayout];
  NSUInteger idx = 0;
  NSPoint point = startPoint;
  for (NSString * str in [layoutStr componentsSeparatedByString:@"\n"]) {
    NSUInteger count = [str componentsSeparatedByString:@" "].count;
    for (NSUInteger i = 0; i < count; ++i) {
      HeatMapKey * key = self.keys[idx++];
      CGFloat width = [key widthForSpaceSize:self.spaceSize];
      key.frame = NSMakeRect(round(point.x), round(point.y), round(width),
                             round(self.spaceSize * 4));
      point.x += key.frame.size.width + self.spaceSize;
    }
    point.x = startPoint.x;
    point.y += self.spaceSize * 5;
  }
}

- (HeatMapKey *)keyAtPoint:(NSPoint)point {
  CGPoint thePoint = NSPointToCGPoint(point);
  for (HeatMapKey * key in self.keys) {
    if (CGRectContainsPoint(NSRectToCGRect(key.frame), thePoint)) {
      return key;
    }
  }
  return nil;
}

- (HeatMapKey *)keyForCode:(int)code {
  for (HeatMapKey * key in self.keys) {
    if (key.keyCode == code) {
      return key;
    }
  }
  return nil;
}

- (NSIndexSet *)visibleKeyCodes {
  if (self.showSpaceBar) {
    return self.codesWithSpace;
  } else {
    return self.codesWithoutSpace;
  }
}

- (BOOL)showSpaceBar {
  return ![self keyForCode:49].ignoreValue;
}

- (void)setShowSpaceBar:(BOOL)x {
  [self keyForCode:49].ignoreValue = !x;
}

@end
