//
//  HeatMapKey.h
//  HeatKey
//
//  Created by Alex Nichol on 10/10/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeatMapKey : NSObject

- (id)initWithShorthand:(NSString *)str;

@property (readwrite) char type;
@property (readwrite) NSRect frame;
@property (readwrite) int keyCode;
@property (readwrite) BOOL visible;
@property (readwrite) BOOL ignoreValue;

- (CGFloat)widthForSpaceSize:(CGFloat)spaceSize;

@end
