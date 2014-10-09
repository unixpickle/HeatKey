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
@property (nonatomic, strong) Profile * recording;
@property (nonatomic, strong) KeyLogger * logger;

- (void)showProfileInfo;
- (void)hideProfileInfo;

- (BOOL)hasProfileNamed:(NSString *)name;
- (NSString *)findUnusedName;
- (Profile *)createNewProfile;

- (void)removeProfile:(Profile *)profile;
- (void)startRecording;
- (void)stopRecording;

@end

@implementation AppDelegate

- (id)init {
  if ((self = [super init])) {
    // TODO: here, attempt to decode [profiles] from a file.
    __weak AppDelegate * weakSelf = self;
    self.profiles = [[NSMutableArray alloc] init];
    self.logger = [[KeyLogger alloc] init];
    self.logger.callback = ^(int code, int modifiers) {
      [weakSelf.recording addKeyPress:code modifiers:modifiers];
      [weakSelf.heatMapView setNeedsDisplay:YES];
    };
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

- (Profile *)currentProfile {
  NSInteger row = self.tableView.selectedRow;
  if (row < 0) {
    return nil;
  }
  NSAssert(row < self.profiles.count,
           @"Invalid profile index");
  return self.profiles[row];
}

#pragma mark - UI Actions -

- (IBAction)addPressed:(id)sender {
  [self.profiles addObject:[self createNewProfile]];
  [self.tableView reloadData];
  NSIndexSet * set = [NSIndexSet indexSetWithIndex:self.profiles.count - 1];
  [self.tableView selectRowIndexes:set byExtendingSelection:NO];
}

- (IBAction)removePressed:(id)sender {
  [self removeProfile:self.currentProfile];
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

- (IBAction)recordPressed:(id)sender {
  if (self.recording) {
    if (self.recording == self.currentProfile) {
      [self stopRecording];
    } else {
      [self stopRecording];
      [self startRecording];
    }
  } else {
    [self startRecording];
  }
}

#pragma mark - Profile Info Views -

- (void)showProfileInfo {
  self.heatMapView.profile = self.currentProfile;
  [self.heatMapView setNeedsDisplay:YES];
  for (NSView * view in @[self.shiftCheck, self.commandCheck, self.optionCheck,
                          self.controlCheck, self.heatMapView,
                          self.recordButton]) {
    [view setHidden:NO];
  }
  self.headerLabel.stringValue = @"Profile Information";
  self.removeButton.enabled = YES;
  if (self.currentProfile == self.recording) {
    self.recordButton.title = @"Stop Recording";
  } else {
    self.recordButton.title = @"Start Recording";
  }
}

- (void)hideProfileInfo {
  for (NSView * view in @[self.shiftCheck, self.commandCheck, self.optionCheck,
                          self.controlCheck, self.heatMapView,
                          self.recordButton]) {
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
  if (!self.currentProfile) {
    [self hideProfileInfo];
  } else {
    [self showProfileInfo];
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

#pragma mark - Managing Profiles -

- (void)removeProfile:(Profile *)profile {
  if (profile == self.recording) {
    [self stopRecording];
  }
  [self.profiles removeObject:profile];
  [self.tableView reloadData];
  [self.tableView deselectAll:nil];
}

- (void)startRecording {
  if (![self.logger beginLogging]) {
    return;
  }
  self.recording = self.currentProfile;
  self.recordButton.title = @"Stop Recording";
}

- (void)stopRecording {
  [self.logger stopLogging];
  if (self.recording == self.currentProfile) {
    self.recordButton.title = @"Start Recording";
  }
  self.recording = nil;
}

@end
