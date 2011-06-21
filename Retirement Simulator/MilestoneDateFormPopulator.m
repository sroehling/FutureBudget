//
//  MilestoneDateFormPopulator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MilestoneDateFormPopulator.h"

#import "FormPopulator.h"
#import "FormInfo.h"
#import "SectionInfo.h"
#import "TextFieldEditInfo.h"
#import "DateFieldEditInfo.h"
#import "MilestoneDate.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "StaticFormInfoCreator.h"
#import "LocalizationHelper.h"

@implementation MilestoneDateFormPopulator

@synthesize varDateRuntimeInfo;

-(id) initWithRuntimeInfo:(VariableDateRuntimeInfo*)theRuntimeInfo
{
	self = [super init];
	if(self)
	{
		self.varDateRuntimeInfo = theRuntimeInfo;
	}
	return self;
}

- (id) init
{
	assert(0); // must call init above.
	return nil;
}

- (void)populateForMilestoneDate:(MilestoneDate*)milestoneDate
{
    self.formInfo.title = LOCALIZED_STR(@"MILESTONE_DATE_FORM_TITLE");
    
    SectionInfo *sectionInfo = [self nextSection];
    [sectionInfo addFieldEditInfo:[TextFieldEditInfo createForObject:milestoneDate 
                                                              andKey:@"name" 
			andLabel:LOCALIZED_STR(@"MILESTONE_DATE_NAME_TEXT_FIELD_LABEL")]];
    [sectionInfo addFieldEditInfo:[DateFieldEditInfo createForObject:milestoneDate 
            andKey:@"date" 
			andLabel:LOCALIZED_STR(@"MILESTONE_DATE_DATE_FIELD_LABEL")]];

}

- (UIViewController*)milestoneDateAddViewController:(MilestoneDate*)milestoneDate
{
    [self populateForMilestoneDate:milestoneDate];
    GenericFieldBasedTableAddViewController *controller = [[[GenericFieldBasedTableAddViewController alloc]
         initWithFormInfoCreator:[StaticFormInfoCreator createWithFormInfo:self.formInfo] 
        andNewObject:milestoneDate] autorelease];
    controller.popDepth =1;
    return controller;
    
}

- (UIViewController*)milestoneDateEditViewController:(MilestoneDate*)milestoneDate
{
    [self populateForMilestoneDate:milestoneDate];
    UIViewController *controller = [[[GenericFieldBasedTableEditViewController alloc] initWithFormInfoCreator:[StaticFormInfoCreator createWithFormInfo:self.formInfo]] autorelease];

    return controller;
    
}

-(void)dealloc
{
	[super dealloc];
	[varDateRuntimeInfo release];
}

@end
