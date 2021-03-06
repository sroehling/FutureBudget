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
#import "DataModelController.h"
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
@synthesize dateHelper;

- (id) initWithCoreData:(DataModelController*)theCoreData
{
	self = [super init];
	if(self)
	{
		assert(theCoreData != nil);
		self.coreData = theCoreData;
		
		UserScenario *theScenario = [self.coreData 
			createDataModelObject:USER_SCENARIO_ENTITY_NAME];
		theScenario.name = @"test";
		self.testScenario = theScenario;
        self.dateHelper = [[[DateHelper alloc] init] autorelease];
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
	[coreData release];
	[testScenario release];
    [dateHelper release];
	[super dealloc];
}



+ (DateSensitiveValueChange*)createTestValueChange:(DataModelController*)coreData 
										   andDateObj:(NSDate*)dateObj andVal:(double)val
{
	DateSensitiveValueChange *valChange = (DateSensitiveValueChange*)[coreData 
		createDataModelObject:DATE_SENSITIVE_VALUE_CHANGE_ENTITY_NAME];
	
	FixedDate *fixedStartDate = (FixedDate*) [coreData 
		createDataModelObject:FIXED_DATE_ENTITY_NAME];
	fixedStartDate.date = dateObj;
	
	valChange.startDate = fixedStartDate;
	valChange.valueAfterChange = [NSNumber numberWithDouble:val];
	return valChange;
}

+ (DateSensitiveValueChange*)createTestValueChange:(DataModelController*)coreData 
										   andDate:(NSString*)dateStr andVal:(double)val
{
    DateHelper *dateHelperForChangeDate = [[[DateHelper alloc] init] autorelease];
    
	NSDate *theDate = [dateHelperForChangeDate dateFromStr:dateStr];
	return [TestCoreDataObjects createTestValueChange:coreData 
		andDateObj:theDate andVal:val];
}

- (MultiScenarioInputValue*)createTestMultiScenInputVal
{
	MultiScenarioInputValue *testInputVal = [self.coreData createDataModelObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	return testInputVal;
}


- (MultiScenarioInputValue*)multiScenFixedValWithDefault:(double)defaultVal
{
	MultiScenarioInputValue *msFixedVal = [self createTestMultiScenInputVal];
    FixedValue *fixedVal = (FixedValue*)[self.coreData createDataModelObject:FIXED_VALUE_ENTITY_NAME];
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

- (MultiScenarioInputValue*)multiScenFixedDate:(NSString*)defaultDate
{
	MultiScenarioInputValue *msFixedEndDate = [self createTestMultiScenInputVal];
    FixedDate *fixedEndDate = (FixedDate*)[self.coreData createDataModelObject:FIXED_DATE_ENTITY_NAME];
    fixedEndDate.date = [dateHelper dateFromStr:defaultDate];
	[msFixedEndDate setValueForScenario:self.testScenario andInputValue:fixedEndDate];
	return msFixedEndDate;

}


- (MultiScenarioInputValue*)multiScenFixedDateWithDefaultToday
{
	MultiScenarioInputValue *msFixedEndDate = [self createTestMultiScenInputVal];
    FixedDate *fixedEndDate = (FixedDate*)[self.coreData createDataModelObject:FIXED_DATE_ENTITY_NAME];
    fixedEndDate.date = [NSDate date];
	[msFixedEndDate setValueForScenario:self.testScenario andInputValue:fixedEndDate];
	return msFixedEndDate;

}


- (MultiScenarioInputValue*)multiScenBoolValWithDefault:(BOOL)theDefaultVal
{
	MultiScenarioInputValue *msBoolVal = [self createTestMultiScenInputVal];
	BoolInputValue *boolVal = 
		[self.coreData createDataModelObject:BOOL_INPUT_VALUE_ENTITY_NAME];
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
	RelativeEndDate *fixedRelEndDate = (RelativeEndDate*)[self.coreData createDataModelObject:RELATIVE_END_DATE_ENTITY_NAME];
	fixedRelEndDate.monthsOffset = [NSNumber numberWithInt:0];
	[msFixedRelEndDate setValueForScenario:self.testScenario andInputValue:fixedRelEndDate];
	return msFixedRelEndDate;
}



@end
