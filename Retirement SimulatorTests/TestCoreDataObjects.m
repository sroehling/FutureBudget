//
//  TestCoreDataObjects.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestCoreDataObjects.h"
#import "DateSensitiveValueChange.h"
#import "DateSensitiveValue.h"
#import "FixedDate.h"
#import "InMemoryCoreData.h"
#import "DateHelper.h"
#import "MultiScenarioInputValue.h"
#import "FixedValue.h"
#import "BoolInputValue.h"
#import "FixedDate.h"
#import "RelativeEndDate.h"
#import "EventRepeatFrequency.h"
#import "SharedAppValues.h"
#import "UserScenario.h"

@implementation TestCoreDataObjects


@synthesize coreData;
@synthesize testScenario;

- (id) initWithCoreData:(InMemoryCoreData*)theCoreData
{
	self = [super init];
	if(self)
	{
		assert(theCoreData != nil);
		self.coreData = theCoreData;
		
		UserScenario *theScenario = [self.coreData createObj:USER_SCENARIO_ENTITY_NAME];
		theScenario.name = @"test";
		self.testScenario = theScenario;
	}
	return self;
}

- (id) init
{
	assert(0); // must init with core data
	return nil;
}

- (void) dealloc
{
	[super dealloc];
	[coreData release];
	[testScenario release];
}



+ (DateSensitiveValueChange*)createTestValueChange:(InMemoryCoreData*)coreData 
										   andDateObj:(NSDate*)dateObj andVal:(double)val
{
	DateSensitiveValueChange *valChange = (DateSensitiveValueChange*)[coreData createObj:DATE_SENSITIVE_VALUE_CHANGE_ENTITY_NAME];
	
	FixedDate *fixedStartDate = (FixedDate*) [coreData createObj:FIXED_DATE_ENTITY_NAME];
	fixedStartDate.date = dateObj;
	
	valChange.startDate = fixedStartDate;
	valChange.newValue = [NSNumber numberWithDouble:val];
	return valChange;
}

+ (DateSensitiveValueChange*)createTestValueChange:(InMemoryCoreData*)coreData 
										   andDate:(NSString*)dateStr andVal:(double)val
{
	NSDate *theDate = [DateHelper dateFromStr:dateStr];
	return [TestCoreDataObjects createTestValueChange:coreData 
		andDateObj:theDate andVal:val];
}

- (MultiScenarioInputValue*)createTestMultiScenInputVal
{
	MultiScenarioInputValue *testInputVal = [self.coreData createObj:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	testInputVal.dataModelInterface = self.coreData;
	return testInputVal;
}


- (MultiScenarioInputValue*)multiScenFixedValWithDefault:(double)defaultVal
{
	MultiScenarioInputValue *msFixedVal = [self createTestMultiScenInputVal];
    FixedValue *fixedVal = (FixedValue*)[self.coreData createObj:FIXED_VALUE_ENTITY_NAME];
    fixedVal.value = [NSNumber numberWithDouble:defaultVal];
	[msFixedVal setValueForScenario:self.testScenario andInputValue:fixedVal];
	return msFixedVal;
}

- (MultiScenarioInputValue*)multiScenInputValueWithDefaultFixedVal:(MultiScenarioInputValue*)fixedVal
{
	InputValue *defaultFixedVal = [fixedVal getDefaultValue]; 

	MultiScenarioInputValue *msInputVal = [self createTestMultiScenInputVal];
	[msInputVal setValueForScenario:self.testScenario andInputValue:defaultFixedVal];
	return msInputVal;
}

- (MultiScenarioInputValue*)multiScenFixedDateWithDefaultToday
{
	MultiScenarioInputValue *msFixedEndDate = [self createTestMultiScenInputVal];
    FixedDate *fixedEndDate = (FixedDate*)[self.coreData createObj:FIXED_DATE_ENTITY_NAME];
    fixedEndDate.date = [NSDate date];
	[msFixedEndDate setValueForScenario:self.testScenario andInputValue:fixedEndDate];
	return msFixedEndDate;

}

- (MultiScenarioInputValue*)multiScenBoolValWithDefault:(BOOL)theDefaultVal
{
	MultiScenarioInputValue *msBoolVal = [self createTestMultiScenInputVal];
	BoolInputValue *boolVal = 
		[self.coreData createObj:BOOL_INPUT_VALUE_ENTITY_NAME];
	boolVal.isTrue = [NSNumber numberWithBool:theDefaultVal];
	[msBoolVal setValueForScenario:self.testScenario andInputValue:boolVal];
	return msBoolVal;

}

- (MultiScenarioInputValue*)multiScenarioRepeatFrequencyOnce
{
	EventRepeatFrequency *repeatOnce = [EventRepeatFrequency createInDataModel:self.coreData 
		andPeriod:kEventPeriodOnce andMultiplier:1];
		
	assert(repeatOnce != nil);
	MultiScenarioInputValue *msRepeatFreq = [self createTestMultiScenInputVal];
	[msRepeatFreq setValueForScenario:self.testScenario andInputValue:repeatOnce];
	return msRepeatFreq;

}

- (MultiScenarioInputValue*)multiScenRelEndDateWithImmediateDefault
{
	MultiScenarioInputValue *msFixedRelEndDate =[self createTestMultiScenInputVal];
	RelativeEndDate *fixedRelEndDate = (RelativeEndDate*)[self.coreData createObj:RELATIVE_END_DATE_ENTITY_NAME];
	fixedRelEndDate.years = [NSNumber numberWithInt:0];
	fixedRelEndDate.months = [NSNumber numberWithInt:0];
	fixedRelEndDate.weeks = [NSNumber numberWithInt:0];
	[msFixedRelEndDate setValueForScenario:self.testScenario andInputValue:fixedRelEndDate];
	return msFixedRelEndDate;
}



@end
