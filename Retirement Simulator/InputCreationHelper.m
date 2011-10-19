//
//  InputCreationHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputCreationHelper.h"

#import "MultiScenarioInputValue.h"
#import "FixedValue.h"
#import "DataModelController.h"
#import "BoolInputValue.h"
#import "SharedAppValues.h"
#import "EventRepeatFrequency.h"
#import "FixedDate.h"
#import "RelativeEndDate.h"
#import "NeverEndDate.h"
#import "MultiScenarioAmount.h"
#import "MultiScenarioGrowthRate.h"
#import "MultiScenarioSimDate.h"
#import "MultiScenarioSimEndDate.h"

@implementation InputCreationHelper


+ (MultiScenarioInputValue*)multiScenFixedValWithDefault:(double)defaultVal
{
	MultiScenarioInputValue *msFixedVal = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
    FixedValue *fixedVal = 
		(FixedValue*)[[DataModelController theDataModelController]insertObject:FIXED_VALUE_ENTITY_NAME];
    fixedVal.value = [NSNumber numberWithDouble:defaultVal];
	[msFixedVal setDefaultValue:fixedVal];
	return msFixedVal;
}

+ (MultiScenarioInputValue*)multiScenInputValueWithDefaultFixedVal:(MultiScenarioInputValue*)fixedVal
{
	InputValue *defaultFixedVal = [fixedVal getDefaultValue]; 

	MultiScenarioInputValue *msInputVal = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	[msInputVal setDefaultValue:defaultFixedVal];
	return msInputVal;
}

+ (MultiScenarioAmount*)multiScenAmountWithDefault:(double)defaultVal
{
	MultiScenarioAmount *msAmount = 
		[[DataModelController theDataModelController] 
			insertObject:MULTI_SCEN_AMOUNT_ENTITY_NAME];
	assert(defaultVal >= 0.0);		
    msAmount.defaultFixedAmount = [InputCreationHelper multiScenFixedValWithDefault:defaultVal];
	msAmount.amount = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:
		msAmount.defaultFixedAmount];

	return msAmount;
}


+ (MultiScenarioGrowthRate*)multiScenGrowthRateWithDefault:(double)defaultVal
{
	MultiScenarioGrowthRate *msGrowthRate = 
		[[DataModelController theDataModelController] 
			insertObject:MULTI_SCEN_GROWTH_RATE_ENTITY_NAME];
			
    msGrowthRate.defaultFixedGrowthRate = [InputCreationHelper multiScenFixedValWithDefault:defaultVal];
	msGrowthRate.growthRate = 
		[InputCreationHelper multiScenInputValueWithDefaultFixedVal:msGrowthRate.defaultFixedGrowthRate];
	
			
	return msGrowthRate;
}

+ (MultiScenarioInputValue*)multiScenBoolValWithDefault:(BOOL)theDefaultVal
{
	MultiScenarioInputValue *msBoolVal = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	BoolInputValue *boolVal = 
		[[DataModelController theDataModelController] 
		insertObject:BOOL_INPUT_VALUE_ENTITY_NAME];
	boolVal.isTrue = [NSNumber numberWithBool:theDefaultVal];
	[msBoolVal setDefaultValue:boolVal];
	return msBoolVal;

}

+ (MultiScenarioInputValue*)multiScenarioRepeatFrequencyOnce
{
	EventRepeatFrequency *repeatOnce = [SharedAppValues singleton].repeatOnceFreq;
	assert(repeatOnce != nil);
	MultiScenarioInputValue *msRepeatFreq = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	[msRepeatFreq setDefaultValue:repeatOnce];
	return msRepeatFreq;

}

+ (MultiScenarioInputValue*)multiScenFixedDateWithDefaultToday
{
	MultiScenarioInputValue *msFixedEndDate = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
    FixedDate *fixedEndDate = (FixedDate*)[[
            DataModelController theDataModelController] insertObject:FIXED_DATE_ENTITY_NAME];
    fixedEndDate.date = [NSDate date];
	[msFixedEndDate setDefaultValue:fixedEndDate];
	return msFixedEndDate;

}

+ (MultiScenarioInputValue*)multiScenRelEndDateWithImmediateDefault
{
	MultiScenarioInputValue *msFixedRelEndDate = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	RelativeEndDate *fixedRelEndDate = (RelativeEndDate*)[[DataModelController theDataModelController] insertObject:RELATIVE_END_DATE_ENTITY_NAME];
	fixedRelEndDate.years = [NSNumber numberWithInt:0];
	fixedRelEndDate.months = [NSNumber numberWithInt:0];
	fixedRelEndDate.weeks = [NSNumber numberWithInt:0];
	[msFixedRelEndDate setDefaultValue:fixedRelEndDate];
	return msFixedRelEndDate;
}

+ (MultiScenarioInputValue*)multiScenNeverEndDate
{
	MultiScenarioInputValue *msNeverEndDate = 
		[[DataModelController theDataModelController] 
		insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	[msNeverEndDate setDefaultValue:[SharedAppValues singleton].sharedNeverEndDate];
	return msNeverEndDate;
}

+(MultiScenarioSimDate*)multiScenSimDateWithDefaultToday
{
	MultiScenarioSimDate *msSimDate = 
		[[DataModelController theDataModelController] 
		insertObject:MULTI_SCEN_SIM_DATE_ENTITY_NAME];

    msSimDate.defaultFixedSimDate = [InputCreationHelper multiScenFixedDateWithDefaultToday];
	msSimDate.simDate = [InputCreationHelper multiScenInputValueWithDefaultFixedVal:msSimDate.defaultFixedSimDate];

	return msSimDate;
}

+(MultiScenarioSimEndDate*)multiScenSimEndDateWithDefaultNeverEndDate
{
	MultiScenarioSimEndDate *msSimEndDate = 
		[[DataModelController theDataModelController] 
		insertObject:MULTI_SCEN_SIM_END_DATE_ENTITY_NAME];
		
    msSimEndDate.defaultFixedSimDate = [InputCreationHelper multiScenFixedDateWithDefaultToday];
	msSimEndDate.defaultFixedRelativeEndDate = [InputCreationHelper multiScenRelEndDateWithImmediateDefault];
	msSimEndDate.simDate = [InputCreationHelper multiScenNeverEndDate];
	return msSimEndDate;
}


@end
