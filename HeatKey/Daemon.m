//
//  Daemon.m
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import "Daemon.h"

static BOOL RunAdminScript(NSString * identArg) {
  // Why didn't I use "X" instead of AppleScript?
  //
  //   - I hate "deprecated" errors, so I didn't use
  //     AuthorizationExecuteWithPrivileges().
  //   - I hate code signing, so I didn't use SMJobBless().
  //   - I hate telling users to run an app as root through Terminal
  
  NSBundle * bundle = [NSBundle mainBundle];
  NSString * daemonPath = [bundle pathForResource:@"HeatKeyDaemon" ofType:nil];
  
  // Escape the path for the AppleScript code
  NSArray * escapeChars = @[@"\\", @"\"", @" "];
  for (NSString * escape in escapeChars) {
    NSString * newStr = [@"\\" stringByAppendingString:escape];
    daemonPath = [daemonPath stringByReplacingOccurrencesOfString:escape
                                                       withString:newStr];
  }
  
  // Generate an AppleScript which runs the command as root in the background.
  NSString * source = [NSString stringWithFormat:@"do shell script \"%@ %@"
                       @" >/dev/null 2>&1 & \" with administrator privileges",
                       daemonPath, identArg];
  
  // Run the script synchronously
  NSAppleScript * script = [[NSAppleScript alloc] initWithSource:source];
  NSDictionary * errors;
  [script executeAndReturnError:&errors];
  if ([errors[NSAppleScriptErrorNumber] isEqualToNumber:@(-128)]) {
    // Error -128 is "user cancelled" -- the only way password entry could have
    // failed as far as I know.
    return NO;
  } else {
    return YES;
  }
}

id<DaemonService> LaunchDaemonService() {
  NSString * distIdentifier = [@(arc4random()) description];
  if (!RunAdminScript(distIdentifier)) {
    return nil;
  }
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
