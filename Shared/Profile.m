//
//  Profile.m
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import "Profile.h"

static NSNumber * _ProfileKey(int key, int modifiers) {
  return @(key | (modifiers << 16));
}

@implementation Profile

+ (int)modifiersMaskWithShift:(BOOL)shift command:(BOOL)command
                       option:(BOOL)option control:(BOOL)control {
  return (shift ? 1 : 0) | (command ? 2 : 0) | (option ? 4 : 0) |
         (control ? 8 : 0);
}

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

- (void)addKeyPress:(int)key modifiers:(int)flags {
  [self addKeyPresses:key modifiers:flags count:1];
}

- (void)addKeyPresses:(int)key modifiers:(int)flags
                count:(unsigned long long)count {
  NSNumber * k = _ProfileKey(key, flags);
  NSNumber * number = self.keyCounts[k];
  if (!number) {
    self.keyCounts[k] = @(count);
  } else {
    self.keyCounts[k] = @(number.unsignedLongLongValue + count);
  }
}

- (unsigned long long)keyCountsForKey:(int)key modifiers:(int)modifiers {
  return [self.keyCounts[_ProfileKey(key, modifiers)] unsignedLongLongValue];
}

- (unsigned long long)maximumCount:(int)modifiers {
  unsigned long long result = 0;
  for (NSNumber * key in [self.keyCounts allKeys]) {
    if (([key intValue] & 0xff0000) != (modifiers << 16)) {
      continue;
    }
    unsigned long long value = [self.keyCounts[key] unsignedLongLongValue];
    result = MAX(result, value);
  }
  return result;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.name forKey:@"name"];
  [aCoder encodeObject:self.keyCounts forKey:@"keyCounts"];
}

@end
