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
#import "TextFieldEditInfo.h"
#import "DateFieldEditInfo.h"
#import "MilestoneDate.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "StaticFormInfoCreator.h"
#import "NumberFieldEditInfo.h"

#import "VariableValueRuntimeInfo.h"
#import "DateSensitiveValueChangeAddedListener.h"
#import "VariableDateFieldEditInfo.h"
#import "LocalizationHelper.h"
#import "VariableDateRuntimeInfo.h"

@implementation DateSensitiveValueChangeFormPopulator


- (void)populateValueChange:(DateSensitiveValueChange*)dsValueChange
	andVariableValRuntimeInfo:(VariableValueRuntimeInfo*)valRuntimeInfo
{
	
	self.formInfo.title = [NSString stringWithFormat:LOCALIZED_STR(@"VALUE_CHANGE_VALUE_CHANGE_FORMAT"),valRuntimeInfo.valueTitle];
	

	SectionInfo *sectionInfo = [self nextSection];
		
	[sectionInfo addFieldEditInfo:[VariableDateFieldEditInfo createForObject:dsValueChange andKey:@"startDate" andLabel:LOCALIZED_STR(@"VALUE_CHANGE_VALUE_CHANGE_START_DATE_LABEL")
	andDefaultValueKey:@"defaultFixedStartDate" andVarDateRuntimeInfo:[VariableDateRuntimeInfo createForDateSensitiveValue:valRuntimeInfo]]];

	NSString *newValueLabel = [NSString stringWithFormat:LOCALIZED_STR(@"VALUE_CHANGE_NEW_VALUE_FORMAT"),valRuntimeInfo.valueTitle];
	[sectionInfo addFieldEditInfo:[NumberFieldEditInfo 
								   createForObject:dsValueChange andKey:@"newValue" andLabel:newValueLabel
								   andNumberFormatter:valRuntimeInfo.valueFormatter]];
	
}

- (UIViewController*)addViewControllerForValueChange:(DateSensitiveValueChange*)valueChange
	andVariableValRuntimeInfo:(VariableValueRuntimeInfo*)valRuntimeInfo andParentVariableValue:(VariableValue*)varValue
{
	[self populateValueChange:valueChange andVariableValRuntimeInfo:valRuntimeInfo];
	
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
{
	[self populateValueChange:valueChange andVariableValRuntimeInfo:valRuntimeInfo];
	
    UIViewController *controller = [[[GenericFieldBasedTableEditViewController alloc]
			initWithFormInfoCreator:[StaticFormInfoCreator createWithFormInfo:self.formInfo]] autorelease];
	
    return controller;
    
}

@end
