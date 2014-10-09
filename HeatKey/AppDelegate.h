//
//  AppDelegate.h
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Profile.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource,
                                   NSTableViewDelegate>

@property (nonatomic, weak) IBOutlet NSTableView * tableView;
@property (nonatomic, weak) IBOutlet NSButton * removeButton;
@property (nonatomic, weak) IBOutlet NSWindow * window;

- (IBAction)addPressed:(id)sender;
- (IBAction)removePressed:(id)sender;

@end

