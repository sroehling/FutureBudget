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
#import "SectionHeaderWithSubtitle.h"
#import "LocalizationHelper.h"
#import "SectionInfo.h"


@implementation MilestoneDateSectionInfo

@synthesize varDateRuntimeInfo;

-(id)initWithRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo
	andParentController:(UIViewController*)theParentController
{
	self = [super initWithHelpInfo:@"milestoneDate" andParentController:theParentController];
	if(self)
	{
		assert(theParentController != nil);
		assert(theVarDateRuntimeInfo != nil);
		
		self.varDateRuntimeInfo = theVarDateRuntimeInfo;
		self.parentViewController = theParentController;
		self.title =  LOCALIZED_STR(@"VARIABLE_DATE_MILESTONE_DATE_SECTION_TITLE");

	}
	return self;
}

- (id) init
{
	assert(0); // must call the init above
	return nil;
}

-(void)addButtonPressedInSectionHeader:(UIViewController*)parentView
{
    assert(self.parentViewController != nil);
    NSLog(@"Add milestone");
    
    MilestoneDate *newMilestoneDate = (MilestoneDate*)
        [[DataModelController theDataModelController]insertObject:MILESTONE_DATE_ENTITY_NAME];
    

    MilestoneDateFormPopulator *formPopulator = [[[MilestoneDateFormPopulator alloc] 
		initWithRuntimeInfo:self.varDateRuntimeInfo
		andParentController:self.parentViewController] autorelease];
    UIViewController *controller =  [formPopulator milestoneDateAddViewController:newMilestoneDate];
    
    [self.parentViewController.navigationController pushViewController:controller animated:YES];
}

- (void)dealloc
{
	[super dealloc];
	[varDateRuntimeInfo release];
}



@end
