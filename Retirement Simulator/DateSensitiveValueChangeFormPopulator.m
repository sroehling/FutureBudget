//
//  DateSensitiveValueChangeFormPopulator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueChangeFormPopulator.h"
#import "DateSensitiveValueChange.h"

#import "FormPopulator.h"
#import "FormInfo.h"
#import "SectionInfo.h"
#import "DateFieldEditInfo.h"
#import "MilestoneDate.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "StaticFormInfoCreator.h"
#import "NumberFieldEditInfo.h"

#import "VariableValueRuntimeInfo.h"
#import "DateSensitiveValueChangeAddedListener.h"
#import "SimDateFieldEditInfo.h"
#import "LocalizationHelper.h"
#import "SimDateRuntimeInfo.h"

@implementation DateSensitiveValueChangeFormPopulator


- (void)populateValueChange:(DateSensitiveValueChange*)dsValueChange
	andVariableValRuntimeInfo:(VariableValueRuntimeInfo*)valRuntimeInfo
	andVariableValue:(VariableValue*)varValue
{
	
	self.formInfo.title = [NSString stringWithFormat:LOCALIZED_STR(@"VALUE_CHANGE_VALUE_CHANGE_FORMAT"),
	 LOCALIZED_STR(valRuntimeInfo.valueTitleKey)];
	

	SectionInfo *sectionInfo = [self nextSection];
	
	SimDateRuntimeInfo *varDateInfo = [SimDateRuntimeInfo createForDateSensitiveValue:valRuntimeInfo andVariableValue:varValue];
		
	[sectionInfo addFieldEditInfo:[SimDateFieldEditInfo createForObject:dsValueChange andKey:@"startDate" andLabel:LOCALIZED_STR(@"VALUE_CHANGE_VALUE_CHANGE_START_DATE_LABEL")
	andDefaultFixedDate:dsValueChange.defaultFixedStartDate andVarDateRuntimeInfo:varDateInfo andShowEndDates:FALSE
		andDefaultRelEndDateKey:nil]];

	NSString *newValueLabel = [NSString stringWithFormat:LOCALIZED_STR(@"VALUE_CHANGE_NEW_VALUE_FORMAT"),
							   LOCALIZED_STR(valRuntimeInfo.valueTitleKey)];
	NSString *newValuePlaceholder = 
		[NSString stringWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_VALUE_CHANGE_NEW_VALUE_PLACEHOLDER_FORMAT"),
		       LOCALIZED_STR(valRuntimeInfo.valueTitleKey)];
		
	[sectionInfo addFieldEditInfo:[NumberFieldEditInfo 
			createForObject:dsValueChange andKey:@"newValue" andLabel:newValueLabel
			andPlaceholder:newValuePlaceholder 
			andNumberFormatter:valRuntimeInfo.valueFormatter andValidator:valRuntimeInfo.valueValidator]];
	
}

- (UIViewController*)addViewControllerForValueChange:(DateSensitiveValueChange*)valueChange
	andVariableValRuntimeInfo:(VariableValueRuntimeInfo*)valRuntimeInfo andParentVariableValue:(VariableValue*)varValue
{
	[self populateValueChange:valueChange andVariableValRuntimeInfo:valRuntimeInfo andVariableValue:varValue];
	
    GenericFieldBasedTableAddViewController *controller = [[[GenericFieldBasedTableAddViewController alloc]
															initWithFormInfoCreator:[StaticFormInfoCreator createWithFormInfo:self.formInfo] 
															andNewObject:valueChange] autorelease];
	controller.finshedAddingListener = 
		[[[DateSensitiveValueChangeAddedListener alloc] initWithVariableValue:varValue] autorelease];
    controller.popDepth =1;
    return controller;
    
}

- (UIViewController*)editViewControllerForValueChange:(DateSensitiveValueChange*)valueChange
							andVariableValRuntimeInfo:(VariableValueRuntimeInfo*)valRuntimeInfo
							andParentVariableValue:(VariableValue*)varValue
{
	[self populateValueChange:valueChange andVariableValRuntimeInfo:valRuntimeInfo 
	     andVariableValue:varValue];
	
    UIViewController *controller = [[[GenericFieldBasedTableEditViewController alloc]
			initWithFormInfoCreator:[StaticFormInfoCreator createWithFormInfo:self.formInfo]] autorelease];
	
    return controller;
    
}

@end
