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
#import "FormContext.h"


@implementation MilestoneDateSectionInfo

@synthesize varDateRuntimeInfo;

-(id)initWithRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo
	andFormContext:(FormContext *)theFormContext
{
	self = [super initWithHelpInfo:@"milestoneDate" andFormContext:theFormContext];
	if(self)
	{
		assert(theVarDateRuntimeInfo != nil);
		
		self.varDateRuntimeInfo = theVarDateRuntimeInfo;
				
		self.title =  LOCALIZED_STR(@"VARIABLE_DATE_MILESTONE_DATE_SECTION_TITLE");

	}
	return self;
}

- (id) init
{
	assert(0); // must call the init above
	return nil;
}

-(void)addButtonPressedInSectionHeader:(FormContext*)parentContext
{
    NSLog(@"Add milestone");
    
    MilestoneDate *newMilestoneDate = (MilestoneDate*)
        [parentContext.dataModelController insertObject:MILESTONE_DATE_ENTITY_NAME];
    

    MilestoneDateFormPopulator *formPopulator = [[[MilestoneDateFormPopulator alloc] 
		initWithRuntimeInfo:self.varDateRuntimeInfo
		andFormContext:self.formContext] autorelease];
    UIViewController *controller =  [formPopulator milestoneDateAddViewController:newMilestoneDate];
    
    [parentContext.parentController.navigationController pushViewController:controller animated:YES];
}

- (void)dealloc
{
	[varDateRuntimeInfo release];
	[super dealloc];
}



@end
