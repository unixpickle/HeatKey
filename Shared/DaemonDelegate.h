//
//  DaemonDelegate.h
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DaemonDelegate

- (void)keyPressed:(int)key modifiers:(int)modifiers;
- (BOOL)ping;

@end
