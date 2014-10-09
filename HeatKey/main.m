//
//  main.m
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    
    if (geteuid()) {
      OSStatus myStatus;
      AuthorizationFlags myFlags = kAuthorizationFlagDefaults;
      AuthorizationRef myAuthorizationRef;
      
      myStatus = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, myFlags, &myAuthorizationRef);
      if (myStatus != errAuthorizationSuccess) return myStatus;
      
      AuthorizationItem myItems = {kAuthorizationRightExecute, 0, NULL, 0};
      AuthorizationRights myRights = {1, &myItems};
      myFlags = kAuthorizationFlagDefaults |
      kAuthorizationFlagInteractionAllowed |
      kAuthorizationFlagPreAuthorize |
      kAuthorizationFlagExtendRights;
      myStatus = AuthorizationCopyRights(myAuthorizationRef, &myRights, NULL, myFlags, NULL );
      
      
      if (myStatus != errAuthorizationSuccess) {
        NSRunAlertPanel(@"Cannot run without admin privileges", @"This program cannot tap into the wireless network stack without administrator access.", @"OK", nil, nil);
        return 1;
      }
      
      
      const char * myToolPath = [[[NSBundle mainBundle] executablePath] UTF8String];
      char * myArguments[] = {NULL};
      
      myFlags = kAuthorizationFlagDefaults;
      myStatus = AuthorizationExecuteWithPrivileges(myAuthorizationRef, myToolPath, myFlags, myArguments,
                                                    NULL);
      AuthorizationFree(myAuthorizationRef, kAuthorizationFlagDefaults);
      exit(0);
    }
    return NSApplicationMain(argc, (const char **)argv);
    
  }
}
