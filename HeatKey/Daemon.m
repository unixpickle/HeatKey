//
//  Daemon.m
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import "Daemon.h"

static void RunAdminScript(NSString * identArg) {
  NSBundle * bundle = [NSBundle mainBundle];
  NSString * daemonPath = [bundle pathForResource:@"HeatKeyDaemon" ofType:nil];
  NSArray * escapeChars = @[@"\\", @"\"", @" "];
  for (NSString * escape in escapeChars) {
    NSString * newStr = [@"\\" stringByAppendingString:escape];
    daemonPath = [daemonPath stringByReplacingOccurrencesOfString:escape
                                                       withString:newStr];
  }
  NSString * source = [NSString stringWithFormat:@"do shell script \"%@ %@"
                       @" >/dev/null 2>&1 & \" with administrator privileges",
                       daemonPath, identArg];
  NSAppleScript * script = [[NSAppleScript alloc] initWithSource:source];
  [script executeAndReturnError:nil];
}

id<DaemonService> LaunchDaemonService() {
  NSString * distIdentifier = [@(arc4random()) description];
  RunAdminScript(distIdentifier);
  NSString * connectId = [NSString stringWithFormat:@"HeatKey_%@",
                          distIdentifier];
  NSDate * start = [NSDate date];
  while ([[NSDate date] timeIntervalSinceDate:start] < 1.0) {
    NSConnection * conn = [NSConnection connectionWithRegisteredName:connectId
                                                                host:nil];
    if (conn) {
      [[conn rootProxy] setProtocolForProxy:@protocol(DaemonService)];
      return (id<DaemonService>)[conn rootProxy];
    } else {
      [NSThread sleepForTimeInterval:0.1];
    }
  }
  return nil;
}
