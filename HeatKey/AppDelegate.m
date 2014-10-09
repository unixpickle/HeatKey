//
//  AppDelegate.m
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSMutableArray * profiles;

- (BOOL)hasProfileNamed:(NSString *)name;
- (NSString *)findUnusedName;
- (Profile *)createNewProfile;

@end

@implementation AppDelegate

- (id)init {
  if ((self = [super init])) {
    // TODO: here, attempt to decode [profiles] from a file.
    self.profiles = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [self hideProfileInfo];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:
        (NSApplication *)sender {
  return YES;
}

#pragma mark - UI Actions -

- (IBAction)addPressed:(id)sender {
  [self.profiles addObject:[self createNewProfile]];
  [self.tableView reloadData];
  NSIndexSet * set = [NSIndexSet indexSetWithIndex:self.profiles.count - 1];
  [self.tableView selectRowIndexes:set byExtendingSelection:NO];
}

- (IBAction)removePressed:(id)sender {
  NSInteger index = self.tableView.selectedRow;
  NSAssert(index >= 0 && index < self.profiles.count, @"No profile selected");
  [self.profiles removeObjectAtIndex:self.tableView.selectedRow];
  [self.tableView reloadData];
}

- (IBAction)modifierCheckboxChanged:(id)sender {
  BOOL shift = (self.shiftCheck.state != 0);
  BOOL command = (self.commandCheck.state != 0);
  BOOL option = (self.optionCheck.state != 0);
  BOOL control = (self.controlCheck.state != 0);
  self.heatMapView.flags = [Profile modifiersMaskWithShift:shift command:command
                                                    option:option
                                                   control:control];
  [self.heatMapView setNeedsDisplay:YES];
}

#pragma mark - Profile Info Views -

- (void)showProfileInfo:(Profile *)profile {
  self.heatMapView.profile = profile;
  [self.heatMapView setNeedsDisplay:YES];
  for (NSView * view in @[self.shiftCheck, self.commandCheck, self.optionCheck,
                          self.controlCheck, self.heatMapView]) {
    [view setHidden:NO];
  }
  self.headerLabel.stringValue = @"Profile Information";
  self.removeButton.enabled = YES;
}

- (void)hideProfileInfo {
  for (NSView * view in @[self.shiftCheck, self.commandCheck, self.optionCheck,
                          self.controlCheck, self.heatMapView]) {
    [view setHidden:YES];
  }
  self.headerLabel.stringValue = @"No Profile Selected";
  self.removeButton.enabled = NO;
}

#pragma mark - Table View -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return self.profiles.count;
}

- (id)tableView:(NSTableView *)tableView
      objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row {
  return [self.profiles[row] name];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object
        forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row {
  NSAssert(row < self.profiles.count, @"Invalid row count");
  [(Profile *)self.profiles[row] setName:(NSString *)object];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
  if (self.tableView.selectedRow < 0) {
    [self hideProfileInfo];
  } else {
    [self showProfileInfo:self.profiles[self.tableView.selectedRow]];
  }
}

#pragma mark - Creating Profiles -

- (BOOL)hasProfileNamed:(NSString *)name {
  for (Profile * profile in self.profiles) {
    if ([profile.name isEqual:name]) {
      return YES;
    }
  }
  return NO;
}

- (NSString *)findUnusedName {
  if (![self hasProfileNamed:@"Untitled"]) {
    return @"Untitled";
  }
  for (int i = 1; i < 100; ++i) {
    NSString * name = [[NSString alloc] initWithFormat:@"Untitled %d", i];
    if (![self hasProfileNamed:name]) {
      return name;
    }
  }
  return @"Untitled";
}

- (Profile *)createNewProfile {
  return [[Profile alloc] initWithName:[self findUnusedName]];
}

@end
