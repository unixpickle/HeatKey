//
//  main.m
//  HeatKeyDaemon
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyLogger.h"

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    if (argc != 2) {
      fprintf(stderr, "Usage: HeatKeyDaemon <IPC code>\n");
      return 1;
    }
    KeyLogger * logger = [[KeyLogger alloc] init];
    NSString * name = [NSString stringWithFormat:@"HeatKey_%s", argv[1]];
    NSConnection * connection = [[NSConnection alloc] init];
    [connection setRootObject:logger];
    logger.connection = connection;
    if (![connection registerName:name]) {
      fprintf(stderr, "Failed to listen to IPC messages.");
      return 1;
    }
    
    NSString * noteName = NSConnectionDidDieNotification;
    [[NSNotificationCenter defaultCenter] addObserver:logger
                                             selector:@selector(died:)
                                                 name:noteName
                                               object:connection];
    
    while (YES) {
      [[NSRunLoop currentRunLoop] run];
    }
  }
}
