//
//  HeatMapLayout.h
//  HeatKey
//
//  Created by Alex Nichol on 10/10/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeatMapKey.h"

@interface HeatMapLayout : NSObject

@property (readwrite) BOOL showSpaceBar;
@property (nonatomic, strong, readonly) NSArray * keys;

- (void)performLayout:(NSSize)containedSize;
- (HeatMapKey *)keyAtPoint:(NSPoint)point;
- (HeatMapKey *)keyForCode:(int)code;
- (NSIndexSet *)visibleKeyCodes;

@end
