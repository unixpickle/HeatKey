//
//  DaemonService.h
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import "DaemonDelegate.h"

@protocol DaemonService

- (void)setDelegate:(id<DaemonDelegate>)delegate;
- (void)start;
- (void)stop;
- (void)kill;

@end
