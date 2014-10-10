//
//  HeatMapView.h
//  HeatKey
//
//  Created by Alex Nichol on 10/9/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Profile.h"
#import "HeatMapLayout.h"

@interface HeatMapView : NSView

@property (nonatomic, strong) Profile * profile;
@property (nonatomic, strong) HeatMapLayout * mapLayout;
@property (readwrite) int modifiers;

@end
