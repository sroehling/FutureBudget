//
//  DateSensitiveValueChangeSectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueChangeSectionInfo.h"
#import "DateSensitiveValueChange.h"
#import "DataModelController.h"
#import "FixedDate.h"
#import "LocalizationHelper.h"
#import "VariableValueRuntimeInfo.h"
#import "DateSensitiveValueChangeFormInfoCreator.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "DateSensitiveValueChangeAddedListener.h"

@implementation DateSensitiveValueChangeSectionInfo

@synthesize variableValRuntimeInfo;
@synthesize variableVal;

- (id) initWithVariableValRuntimeInfo:(VariableValueRuntimeInfo*)valRuntimeInfo
	andParentVariableValue:(VariableValue*)varValue 
	andParentController:(UIViewController *)theParentController
{
	self = [super initWithHelpInfo:@"variableValueChange" 
				andParentController:theParentController];
	if(self)
	{
		assert(valRuntimeInfo != nil);
		self.variableValRuntimeInfo = valRuntimeInfo;
		
		assert(varValue != nil);
		self.variableVal = varValue;
		
		self.title =  [NSString stringWithFormat:
			LOCALIZED_STR(@"VARIABLE_VALUE_VALUE_CHANGES_SECTION_TITLE_FORMAT"),
			LOCALIZED_STR(self.variableValRuntimeInfo.valueTitleKey)];

	}
	return self;
}

- (id) init
{
	assert(0); // should not be called
	return nil;
}

- (void) dealloc
{
	[super dealloc];
	[variableValRuntimeInfo release];
	[variableVal release];
}

-(void)addButtonPressedInSectionHeader:(UIViewController*)parentView
{
    assert(self.parentViewController != nil);
    NSLog(@"Add value change");
    
	DateSensitiveValueChange *valueChange = (DateSensitiveValueChange*)
		[[DataModelController theDataModelController]insertObject:DATE_SENSITIVE_VALUE_CHANGE_ENTITY_NAME];

	FixedDate *fixedStartDate = (FixedDate*)[[
		DataModelController theDataModelController] insertObject:FIXED_DATE_ENTITY_NAME];
    fixedStartDate.date = [NSDate date];
    valueChange.defaultFixedStartDate = fixedStartDate;
	
	DateSensitiveValueChangeFormInfoCreator *formInfoCreator = 
		[[[DateSensitiveValueChangeFormInfoCreator alloc] initForValueChange:valueChange 
		andVariableValRuntimeInfo:variableValRuntimeInfo andParentVariableValue:self.variableVal] autorelease];

    GenericFieldBasedTableAddViewController *controller = 
		[[[GenericFieldBasedTableAddViewController alloc] 
		initWithFormInfoCreator:formInfoCreator andNewObject:valueChange] autorelease];
	controller.finshedAddingListener = 
		[[[DateSensitiveValueChangeAddedListener alloc] initWithVariableValue:self.variableVal] autorelease];
    controller.popDepth =1;
    
    [self.parentViewController.navigationController pushViewController:controller animated:YES];
}

@end
