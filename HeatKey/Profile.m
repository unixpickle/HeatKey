//
//  Profile.m
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import "Profile.h"

@implementation Profile

- (id)initWithName:(NSString *)name {
  if ((self = [super init])) {
    self.keyCounts = [[NSMutableDictionary alloc] init];
    self.name = name;
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super init])) {
    self.name = [aDecoder decodeObjectForKey:@"name"];
    NSDictionary * counts = [aDecoder decodeObjectForKey:@"keyCounts"];
    self.keyCounts = [[NSMutableDictionary alloc] initWithDictionary:counts];
  }
  return self;
}

- (void)addKeyPress:(int)key {
  [self addKeyPresses:key count:1];
}

- (void)addKeyPresses:(int)key count:(unsigned long long)count {
  NSNumber * number = self.keyCounts[@(key)];
  if (!number) {
    self.keyCounts[@(key)] = @(count);
  } else {
    self.keyCounts[@(key)] = @(number.unsignedLongLongValue + count);
  }
}

- (unsigned long long)keyCountsForKey:(int)key {
  return [self.keyCounts[@(key)] unsignedLongLongValue];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.name forKey:@"name"];
  [aCoder encodeObject:self.keyCounts forKey:@"keyCounts"];
}

@end
