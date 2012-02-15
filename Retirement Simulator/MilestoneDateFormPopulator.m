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
#import "DateFieldEditInfo.h"
#import "MilestoneDate.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "StaticFormInfoCreator.h"
#import "LocalizationHelper.h"
#import "ManagedObjectFieldInfo.h"
#import "NameFieldEditInfo.h"
#import "DataModelController.h"
#import "FormContext.h"

@implementation MilestoneDateFormPopulator

@synthesize varDateRuntimeInfo;

-(id) initWithRuntimeInfo:(SimDateRuntimeInfo*)theRuntimeInfo
	andFormContext:(FormContext*)theFormContext
{
	self = [super initWithFormContext:theFormContext];
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
	
	ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] initWithManagedObject:milestoneDate andFieldKey:@"name" andFieldLabel:LOCALIZED_STR(@"MILESTONE_DATE_NAME_TEXT_FIELD_LABEL") andFieldPlaceholder:LOCALIZED_STR(@"VARIABLE_DATE_MILESTONE_NAME_PLACEHOLDER")] autorelease];
	NameFieldEditInfo *fieldEditInfo = [[[NameFieldEditInfo alloc] initWithFieldInfo:fieldInfo] autorelease];
    [sectionInfo addFieldEditInfo:fieldEditInfo];
	
	
	sectionInfo = [self nextSection];
    [sectionInfo addFieldEditInfo:[DateFieldEditInfo createForObject:milestoneDate 
            andKey:@"date" 
			andLabel:LOCALIZED_STR(@"MILESTONE_DATE_DATE_FIELD_LABEL")
			andPlaceholder:LOCALIZED_STR(@"VARIABLE_DATE_MILESTONE_DATE_PLACEHOLDER")]];

}

- (UIViewController*)milestoneDateAddViewController:(MilestoneDate*)milestoneDate
{
    [self populateForMilestoneDate:milestoneDate];

// TODO - Allocate a new DataModelController, so that additons to milestone dates
// can be kept separate from other changes. This will also ensure any additions to 
// milestone dates are not lost if a new milestone date is created while creating
// a new input, but the save is canceled.
	
    GenericFieldBasedTableAddViewController *controller = [[[GenericFieldBasedTableAddViewController alloc]
         initWithFormInfoCreator:[StaticFormInfoCreator createWithFormInfo:self.formInfo] 
        andNewObject:milestoneDate andDataModelController:self.formContext.dataModelController] autorelease];
    controller.popDepth =1;
    return controller;
    
}

- (UIViewController*)milestoneDateEditViewController:(MilestoneDate*)milestoneDate
{
    [self populateForMilestoneDate:milestoneDate];
	
    UIViewController *controller = [[[GenericFieldBasedTableEditViewController alloc] 
		initWithFormInfoCreator:[StaticFormInfoCreator createWithFormInfo:self.formInfo]
		andDataModelController:self.formContext.dataModelController] autorelease];

    return controller;
    
}

-(void)dealloc
{
	[varDateRuntimeInfo release];
	[super dealloc];
}

@end
