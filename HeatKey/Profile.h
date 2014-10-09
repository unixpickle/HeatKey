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

- (id)initWithName:(NSString *)name;

- (void)addKeyPress:(int)key;
- (void)addKeyPresses:(int)key count:(unsigned long long)count;
- (unsigned long long)keyCountsForKey:(int)key;

@end
