//
//  KeyLogger.h
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DaemonService.h"

@interface KeyLogger : NSObject <DaemonService> {
  CFRunLoopSourceRef runLoopSource;
  CFMachPortRef eventTap;
}

@property (nonatomic, strong) NSConnection * connection;
@property (nonatomic, strong) id<DaemonDelegate> delegate;

- (void)start;
- (void)stop;
- (void)kill;

- (void)died:(NSNotification *)note;
- (void)pingDelegate;

- (void)dealloc;

@end
