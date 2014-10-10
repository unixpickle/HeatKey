//
//  KeyLogger.h
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol KeyLoggerDelegate

- (void)keyPressed:(int)key modifiers:(int)modifiers;

@end

@interface KeyLogger : NSObject {
  CFRunLoopSourceRef runLoopSource;
  CFMachPortRef eventTap;
}

@property (nonatomic, strong) NSConnection * connection;
@property (nonatomic, strong) id<KeyLoggerDelegate> delegate;

- (BOOL)start;
- (void)stop;

- (void)dealloc;

@end
