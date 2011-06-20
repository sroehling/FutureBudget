//
//  MilestoneDateSectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MilestoneDateSectionInfo.h"
#import "MilestoneDateFormPopulator.h"
#import "DataModelController.h"
#import "MilestoneDate.h"


@implementation MilestoneDateSectionInfo

@synthesize varDateRuntimeInfo;

-(id)initWithRuntimeInfo:(VariableDateRuntimeInfo*)theVarDateRuntimeInfo
{
	self = [super init];
	if(self)
	{
		self.varDateRuntimeInfo = theVarDateRuntimeInfo;
	}
	return self;
}

- (id) init
{
	assert(0); // must call the init above
	return nil;
}

- (void)addObjectButtonPressed
{
    assert(self.parentViewController != nil);
    NSLog(@"Add milestone");
    
    MilestoneDate *newMilestoneDate = (MilestoneDate*)
        [[DataModelController theDataModelController]insertObject:@"MilestoneDate"];
    

    MilestoneDateFormPopulator *formPopulator = [[[MilestoneDateFormPopulator alloc] initWithRuntimeInfo:self.varDateRuntimeInfo] autorelease];
    UIViewController *controller =  [formPopulator milestoneDateAddViewController:newMilestoneDate];
    
    [self.parentViewController.navigationController pushViewController:controller animated:YES];
}

- (void)dealloc
{
	[super dealloc];
	[varDateRuntimeInfo release];
}



@end
