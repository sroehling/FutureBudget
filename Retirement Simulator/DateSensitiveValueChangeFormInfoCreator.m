//
//  DateSensitiveValueChangeFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueChangeFormInfoCreator.h"

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

@implementation DateSensitiveValueChangeFormInfoCreator


@synthesize parentVariableVal;
@synthesize valRuntimeInfo;
@synthesize valueChange;

-(id)initForValueChange:(DateSensitiveValueChange*)theValueChange
						   andVariableValRuntimeInfo:(VariableValueRuntimeInfo*)theValRuntimeInfo
						   andParentVariableValue:(VariableValue*)theVarValue
{
	self = [super init];
	if(self)
	{
		assert(theValueChange != nil);
		assert(theValRuntimeInfo != nil);
		assert(theVarValue != nil);
	
		self.valueChange = theValueChange;
		self.valRuntimeInfo = theValRuntimeInfo;
		self.parentVariableVal = theVarValue;
	}
	return self;
}


- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] initWithParentController:parentController] autorelease];
	
    formPopulator.formInfo.title = [NSString stringWithFormat:
		LOCALIZED_STR(@"VALUE_CHANGE_VALUE_CHANGE_FORMAT"),
		LOCALIZED_STR(valRuntimeInfo.valueTitleKey)];
	
	[formPopulator nextSection];
	
	SimDateRuntimeInfo *varDateInfo = [SimDateRuntimeInfo createForDateSensitiveValue:valRuntimeInfo 
				andVariableValue:self.parentVariableVal];
	
	SimDateFieldEditInfo *simDateFieldEditInfo = [SimDateFieldEditInfo createForObject:self.valueChange 
		andKey:DATE_SENSITIVE_VALUE_CHANGE_START_DATE_KEY
		andLabel:LOCALIZED_STR(@"VALUE_CHANGE_VALUE_CHANGE_START_DATE_LABEL")
		andDefaultFixedDate:self.valueChange.defaultFixedStartDate 
			andVarDateRuntimeInfo:varDateInfo andShowEndDates:FALSE
		andDefaultRelEndDateKey:nil];
		
	[formPopulator.currentSection addFieldEditInfo:simDateFieldEditInfo];

	NSString *newValueLabel = [NSString stringWithFormat:LOCALIZED_STR(@"VALUE_CHANGE_NEW_VALUE_FORMAT"),
							   LOCALIZED_STR(valRuntimeInfo.valueTitleKey)];
	NSString *newValuePlaceholder = 
		[NSString stringWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_VALUE_CHANGE_NEW_VALUE_PLACEHOLDER_FORMAT"),
		       LOCALIZED_STR(valRuntimeInfo.valueTitleKey)];
		
	[formPopulator.currentSection addFieldEditInfo:[NumberFieldEditInfo 
			createForObject:self.valueChange andKey:DATE_SENSITIVE_VALUE_CHANGE_NEW_VALUE_KEY andLabel:newValueLabel
			andPlaceholder:newValuePlaceholder 
			andNumberFormatter:valRuntimeInfo.valueFormatter andValidator:valRuntimeInfo.valueValidator]];


    return formPopulator.formInfo;
}

-(void)dealloc
{
	[super dealloc];
	
	[parentVariableVal release];
	[valRuntimeInfo release];
	[valueChange release];

}


@end
