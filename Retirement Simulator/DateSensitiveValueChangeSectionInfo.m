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
#import "FormContext.h"

@implementation DateSensitiveValueChangeSectionInfo

@synthesize variableValRuntimeInfo;
@synthesize variableVal;


- (id) initWithVariableValRuntimeInfo:(VariableValueRuntimeInfo*)valRuntimeInfo
	andParentVariableValue:(VariableValue*)varValue
	andFormContext:(FormContext*)theFormContext
{
	self = [super initWithHelpInfo:@"variableValueChange" 
				andFormContext:theFormContext];
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
	[variableValRuntimeInfo release];
	[variableVal release];
	[super dealloc];
}

-(void)addButtonPressedInSectionHeader:(FormContext*)parentContext
{
    NSLog(@"Add value change");
    
	DateSensitiveValueChange *valueChange = (DateSensitiveValueChange*)
		[self.formContext.dataModelController insertObject:DATE_SENSITIVE_VALUE_CHANGE_ENTITY_NAME];

	FixedDate *fixedStartDate = (FixedDate*)[self.formContext.dataModelController
		insertObject:FIXED_DATE_ENTITY_NAME];
    fixedStartDate.date = [NSDate date];
    valueChange.defaultFixedStartDate = fixedStartDate;
	
	DateSensitiveValueChangeFormInfoCreator *formInfoCreator = 
		[[[DateSensitiveValueChangeFormInfoCreator alloc] initForValueChange:valueChange 
		andVariableValRuntimeInfo:variableValRuntimeInfo andParentVariableValue:self.variableVal] autorelease];
    formInfoCreator.promptForDateWhenFirstEditingStartDate = TRUE;

    GenericFieldBasedTableAddViewController *controller = 
		[[[GenericFieldBasedTableAddViewController alloc] 
		initWithFormInfoCreator:formInfoCreator andNewObject:valueChange 
		andDataModelController:self.formContext.dataModelController] autorelease];
	controller.finshedAddingListener = 
		[[[DateSensitiveValueChangeAddedListener alloc] initWithVariableValue:self.variableVal] autorelease];
    controller.popDepth =1;
    
    [parentContext.parentController.navigationController pushViewController:controller animated:YES];
}

@end
