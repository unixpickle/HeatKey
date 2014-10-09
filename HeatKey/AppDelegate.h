//
//  AppDelegate.h
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HeatMapView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource,
                                   NSTableViewDelegate>

@property (nonatomic, weak) IBOutlet NSTableView * tableView;
@property (nonatomic, weak) IBOutlet NSButton * removeButton;
@property (nonatomic, weak) IBOutlet NSWindow * window;

@property (nonatomic, weak) IBOutlet NSTextField * headerLabel;
@property (nonatomic, weak) IBOutlet HeatMapView * heatMapView;
@property (nonatomic, weak) IBOutlet NSButton * shiftCheck;
@property (nonatomic, weak) IBOutlet NSButton * commandCheck;
@property (nonatomic, weak) IBOutlet NSButton * optionCheck;
@property (nonatomic, weak) IBOutlet NSButton * controlCheck;

- (IBAction)addPressed:(id)sender;
- (IBAction)removePressed:(id)sender;
- (IBAction)modifierCheckboxChanged:(id)sender;

- (void)showProfileInfo:(Profile *)profile;
- (void)hideProfileInfo;

@end

