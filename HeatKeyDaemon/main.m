//
//  main.m
//  HeatKeyDaemon
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    if (argc != 2) {
      fprintf(stderr, "Usage: HeatKeyDaemon <IPC code>");
      return 1;
    }
    // TODO: start IPC server here
  }
}
