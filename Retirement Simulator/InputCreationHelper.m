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
#import "BoolInputValue.h"
#import "InflationRate.h"
#import "SharedAppValues.h"
#import "EventRepeatFrequency.h"
#import "FixedDate.h"
#import "RelativeEndDate.h"
#import "NeverEndDate.h"
#import "MultiScenarioAmount.h"
#import "MultiScenarioGrowthRate.h"
#import "MultiScenarioSimDate.h"
#import "MultiScenarioSimEndDate.h"
#import "DataModelController.h"

@implementation InputCreationHelper

@synthesize dataModel;
@synthesize sharedAppVals;

-(id)initWithDataModelController:(DataModelController*)theDataModel
	andSharedAppVals:(SharedAppValues*)theSharedAppVals
{
	self = [super init];
	if(self)
	{
		assert(theDataModel != nil);
		self.dataModel = theDataModel;
		
		assert(theSharedAppVals != nil);
		self.sharedAppVals = theSharedAppVals;
	}
	return self;
}

- (id) init
{
	assert(0); // must init with data model interface and shared app vals
	return nil;
}

-(void)dealloc
{
	[dataModel release];
	[sharedAppVals release];
	[super dealloc];
}

- (MultiScenarioInputValue*)multiScenInputValue
{
	MultiScenarioInputValue *msInputVal = 
		[self.dataModel createDataModelObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	return msInputVal;
}

- (FixedValue*)fixedValueForValue:(double)val
{
    FixedValue *fixedVal = 
		(FixedValue*)[self.dataModel createDataModelObject:FIXED_VALUE_ENTITY_NAME];
    fixedVal.value = [NSNumber numberWithDouble:val];
	return fixedVal;
}

- (MultiScenarioInputValue*)multiScenFixedValWithDefault:(double)defaultVal
{
	MultiScenarioInputValue *msFixedVal = [self multiScenInputValue];
		
    FixedValue *fixedVal = 
		(FixedValue*)[self.dataModel createDataModelObject:FIXED_VALUE_ENTITY_NAME];
    fixedVal.value = [NSNumber numberWithDouble:defaultVal];
	[msFixedVal setDefaultValue:fixedVal];
	return msFixedVal;
}

- (MultiScenarioInputValue*)multiScenInputValueWithDefaultFixedVal:(MultiScenarioInputValue*)fixedVal
{
	InputValue *defaultFixedVal = [fixedVal getDefaultValue]; 

	MultiScenarioInputValue *msInputVal = [self multiScenInputValue];
	
	[msInputVal setDefaultValue:defaultFixedVal];
	return msInputVal;
}

- (MultiScenarioAmount*)multiScenAmountWithDefault:(double)defaultVal
{
	MultiScenarioAmount *msAmount = [self.dataModel createDataModelObject:MULTI_SCEN_AMOUNT_ENTITY_NAME];
	assert(defaultVal >= 0.0);		
    msAmount.defaultFixedAmount = [self multiScenFixedValWithDefault:defaultVal];
	msAmount.amount = [self multiScenInputValueWithDefaultFixedVal:
		msAmount.defaultFixedAmount];

	return msAmount;
}

- (MultiScenarioAmount*)multiScenAmountWithWithDefaultButNoInitialVal:(double)defaultVal
{
	MultiScenarioAmount *msAmount = [self.dataModel createDataModelObject:MULTI_SCEN_AMOUNT_ENTITY_NAME];
	assert(defaultVal >= 0.0);		
    msAmount.defaultFixedAmount = [self multiScenFixedValWithDefault:defaultVal];
	msAmount.amount = [self multiScenInputValue];
	return msAmount;
}

- (MultiScenarioAmount*)multiScenAmountWithNoDefaultAndNoInitialVal
{
	MultiScenarioAmount *msAmount = [self.dataModel createDataModelObject:MULTI_SCEN_AMOUNT_ENTITY_NAME];
    msAmount.defaultFixedAmount = [self multiScenInputValue];
	msAmount.amount = [self multiScenInputValue];
	return msAmount;
}



- (MultiScenarioGrowthRate*)multiScenGrowthRateWithDefault:(double)defaultVal
{
	MultiScenarioGrowthRate *msGrowthRate = 
		[self.dataModel createDataModelObject:MULTI_SCEN_GROWTH_RATE_ENTITY_NAME];
			
    msGrowthRate.defaultFixedGrowthRate = [self multiScenFixedValWithDefault:defaultVal];
	msGrowthRate.growthRate = 
		[self multiScenInputValueWithDefaultFixedVal:msGrowthRate.defaultFixedGrowthRate];
	
			
	return msGrowthRate;
}

- (MultiScenarioGrowthRate*)multiScenGrowthRateWithDefaultButNoInitialVal:(double)defaultVal
{
	MultiScenarioGrowthRate *msGrowthRate = 
		[self.dataModel createDataModelObject:MULTI_SCEN_GROWTH_RATE_ENTITY_NAME];
			
    msGrowthRate.defaultFixedGrowthRate = [self multiScenFixedValWithDefault:defaultVal];
	msGrowthRate.growthRate = [self multiScenInputValue];
	
			
	return msGrowthRate;
}


- (MultiScenarioGrowthRate*)multiScenGrowthRateWithNoDefaultAndNoInitialVal
{
	MultiScenarioGrowthRate *msGrowthRate = 
		[self.dataModel createDataModelObject:MULTI_SCEN_GROWTH_RATE_ENTITY_NAME];
			
    msGrowthRate.defaultFixedGrowthRate = [self multiScenInputValue];
	msGrowthRate.growthRate = [self multiScenInputValue];
	
	return msGrowthRate;
}


- (MultiScenarioGrowthRate*)multiScenDefaultGrowthRate
{
	MultiScenarioGrowthRate *msGrowthRate = 
		[self.dataModel createDataModelObject:MULTI_SCEN_GROWTH_RATE_ENTITY_NAME];
			
	InflationRate *defaultRate = self.sharedAppVals.defaultInflationRate;
	assert(defaultRate != nil);
			
    msGrowthRate.defaultFixedGrowthRate = [self multiScenFixedValWithDefault:0.0];

	MultiScenarioInputValue *msInputVal = [self multiScenInputValue];
	[msInputVal setDefaultValue:defaultRate];
	msGrowthRate.growthRate = msInputVal;
	
			
	return msGrowthRate;
}


- (MultiScenarioInputValue*)multiScenBoolValWithDefault:(BOOL)theDefaultVal
{
	MultiScenarioInputValue *msBoolVal = [self multiScenInputValue];
	
	BoolInputValue *boolVal = 
		[self.dataModel createDataModelObject:BOOL_INPUT_VALUE_ENTITY_NAME];
	boolVal.isTrue = [NSNumber numberWithBool:theDefaultVal];
	[msBoolVal setDefaultValue:boolVal];
	return msBoolVal;

}

- (MultiScenarioInputValue*)multiScenarioRepeatFrequencyOnce
{
	EventRepeatFrequency *repeatOnce = self.sharedAppVals.repeatOnceFreq;
	assert(repeatOnce != nil);
	MultiScenarioInputValue *msRepeatFreq = [self multiScenInputValue];
	[msRepeatFreq setDefaultValue:repeatOnce];
	return msRepeatFreq;

}

- (MultiScenarioInputValue*)multiScenarioRepeatFrequencyMonthly
{
	EventRepeatFrequency *repeatMonthly = self.sharedAppVals.repeatMonthlyFreq;
	assert(repeatMonthly != nil);
	MultiScenarioInputValue *msRepeatFreq = [self multiScenInputValue];
	[msRepeatFreq setDefaultValue:repeatMonthly];
	return msRepeatFreq;
}

- (MultiScenarioInputValue*)multiScenarioRepeatFrequencyYearly
{
	EventRepeatFrequency *repeatYearly = self.sharedAppVals.repeatYearlyFreq;
	assert(repeatYearly != nil);
	MultiScenarioInputValue *msRepeatFreq = [self multiScenInputValue];
	[msRepeatFreq setDefaultValue:repeatYearly];
	return msRepeatFreq;
}


- (MultiScenarioInputValue*)multiScenFixedDateWithDefault:(NSDate*)defaultDate
{
	assert(defaultDate != nil);
	
	MultiScenarioInputValue *msFixedEndDate = [self multiScenInputValue];
	
    FixedDate *fixedEndDate = (FixedDate*)[self.dataModel createDataModelObject:FIXED_DATE_ENTITY_NAME];
    fixedEndDate.date = defaultDate;
	[msFixedEndDate setDefaultValue:fixedEndDate];
	return msFixedEndDate;

}



- (MultiScenarioInputValue*)multiScenFixedDateWithDefaultToday
{
	return [self multiScenFixedDateWithDefault:[NSDate date]];
}

- (MultiScenarioInputValue*)multiScenRelEndDateWithImmediateDefault
{
	MultiScenarioInputValue *msFixedRelEndDate = [self multiScenInputValue];
	
	RelativeEndDate *fixedRelEndDate = (RelativeEndDate*)[self.dataModel createDataModelObject:RELATIVE_END_DATE_ENTITY_NAME];
	fixedRelEndDate.monthsOffset = [NSNumber numberWithInt:0];
	[msFixedRelEndDate setDefaultValue:fixedRelEndDate];
	return msFixedRelEndDate;
}

- (MultiScenarioInputValue*)multiScenNeverEndDate
{
	MultiScenarioInputValue *msNeverEndDate = [self multiScenInputValue];
	
	[msNeverEndDate setDefaultValue:self.sharedAppVals.sharedNeverEndDate];
	return msNeverEndDate;
}

- (MultiScenarioSimDate*)multiScenSimDateWithDefault:(NSDate*)defaultDate
{
	assert(defaultDate != nil);
	
	MultiScenarioSimDate *msSimDate = 
		[self.dataModel createDataModelObject:MULTI_SCEN_SIM_DATE_ENTITY_NAME];

    msSimDate.defaultFixedSimDate = [self multiScenFixedDateWithDefault:defaultDate];
	msSimDate.simDate = [self multiScenInputValueWithDefaultFixedVal:msSimDate.defaultFixedSimDate];

	return msSimDate;

}

- (MultiScenarioSimDate*)multiScenSimDateWithDefaultTodayButNoInitialVal
{
	
	NSDate *defaultDate = [NSDate date];
	
	MultiScenarioSimDate *msSimDate = 
		[self.dataModel createDataModelObject:MULTI_SCEN_SIM_DATE_ENTITY_NAME];

    msSimDate.defaultFixedSimDate = [self multiScenFixedDateWithDefault:defaultDate];
	msSimDate.simDate = [self multiScenInputValue];

	return msSimDate;

}

- (MultiScenarioSimDate*)multiScenSimDateWithNoDefaultAndNoInitialVal
{
	
	MultiScenarioSimDate *msSimDate = 
		[self.dataModel createDataModelObject:MULTI_SCEN_SIM_DATE_ENTITY_NAME];

    msSimDate.defaultFixedSimDate = [self multiScenInputValue];
	msSimDate.simDate = [self multiScenInputValue];

	return msSimDate;

}



- (MultiScenarioSimDate*)multiScenSimDateWithDefaultToday
{
	return [self multiScenSimDateWithDefault:[NSDate date]];
}

- (MultiScenarioSimEndDate*)multiScenSimEndDateWithDefaultNeverEndDate
{
	MultiScenarioSimEndDate *msSimEndDate = 
		[self.dataModel createDataModelObject:MULTI_SCEN_SIM_END_DATE_ENTITY_NAME];
		
    msSimEndDate.defaultFixedSimDate = [self multiScenFixedDateWithDefaultToday];
	msSimEndDate.defaultFixedRelativeEndDate = [self multiScenRelEndDateWithImmediateDefault];
	msSimEndDate.simDate = [self multiScenNeverEndDate];
	return msSimEndDate;
}

- (MultiScenarioSimEndDate*)multiScenSimEndDateWithDefault:(NSDate*)defaultDate
{
	assert(defaultDate != nil);	

	MultiScenarioSimEndDate *msSimEndDate = 
		[self.dataModel createDataModelObject:MULTI_SCEN_SIM_END_DATE_ENTITY_NAME];
		
    msSimEndDate.defaultFixedSimDate = [self multiScenFixedDateWithDefault:defaultDate];
	msSimEndDate.defaultFixedRelativeEndDate = [self multiScenRelEndDateWithImmediateDefault];
	msSimEndDate.simDate = [self multiScenInputValueWithDefaultFixedVal:msSimEndDate.defaultFixedSimDate];
	return msSimEndDate;
}


@end
