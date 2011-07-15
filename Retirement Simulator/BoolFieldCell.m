//
//  BoolFieldCell.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BoolFieldCell.h"
#import "FieldInfo.h"


@implementation BoolFieldCell

@synthesize label;
@synthesize boolSwitch;
@synthesize boolFieldInfo;


-(IBAction)boolSwitchToggled:(id)sender
{
	NSLog(@"Bool switch toggled to %i",self.boolSwitch.on);
	[self.boolFieldInfo setFieldValue:[NSNumber numberWithBool:self.boolSwitch.on]];
}


- (void)dealloc
{
    [super dealloc];
	[label release];
	[boolSwitch release];
	[boolFieldInfo release];
}

@end
