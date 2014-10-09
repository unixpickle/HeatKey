//
//  KeyLogger.h
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void (^ KeyLoggerCallback)(int keyCode, int modifiers);

@interface KeyLogger : NSObject {
  CFRunLoopSourceRef runLoopSource;
  CFMachPortRef eventTap;
}

@property (nonatomic, strong) KeyLoggerCallback callback;

- (BOOL)beginLogging;
- (void)stopLogging;
- (void)dealloc;

@end
