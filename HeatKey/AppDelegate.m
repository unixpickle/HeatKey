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
  // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:
        (NSApplication *)sender {
  return YES;
}

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
    self.removeButton.enabled = NO;
  } else {
    self.removeButton.enabled = YES;
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
