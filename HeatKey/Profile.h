//
//  Profile.h
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject <NSCoding>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSMutableDictionary * keyCounts;

+ (int)modifiersMaskWithShift:(BOOL)shift command:(BOOL)command
                       option:(BOOL)option control:(BOOL)control;

- (id)initWithName:(NSString *)name;

- (void)addKeyPress:(int)key modifiers:(int)flags;
- (void)addKeyPresses:(int)key modifiers:(int)flags
                count:(unsigned long long)count;
- (unsigned long long)keyCountsForKey:(int)key modifiers:(int)modifiers;

@end
