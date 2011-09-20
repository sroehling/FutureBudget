//
//  SimInputHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimInputHelper.h"
#import "MultiScenarioInputValue.h"
#import "ValueAsOfCalculator.h"
#import "ValueAsOfCalculatorCreator.h"
#import "SimDate.h"
#import "BoolInputValue.h"
#import "FixedValue.h"
#import "DateHelper.h"
#import "VariableRateCalculator.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"

@implementation SimInputHelper

+ (double)multiScenValueAsOfDate:(MultiScenarioInputValue*)multiScenDateSensitiveVal
	andDate:(NSDate*)resolveDate
{
	assert(resolveDate != nil);
	id<ValueAsOfCalculator> amtCalc = [ValueAsOfCalculatorCreator createValueAsOfCalc:multiScenDateSensitiveVal];
	double valAsOfDate = [amtCalc valueAsOfDate:resolveDate];
	return valAsOfDate;

}

+ (double)multiScenVariableRateMultiplier:(MultiScenarioInputValue*)multiScenDateSensitiveVal
	sinceStartDate:(NSDate*)startDate asOfDate:(NSDate*)asOfDate
{
	assert(asOfDate != nil);
	assert(startDate != nil);
	assert([DateHelper dateIsEqualOrLater:asOfDate otherDate:startDate]);
	assert(multiScenDateSensitiveVal != nil);

	VariableRateCalculator *rateCalc = [DateSensitiveValueVariableRateCalculatorCreator
		createVariableRateCalc:multiScenDateSensitiveVal
		andStartDate:startDate];
	return [rateCalc valueMultiplierForDate:asOfDate];

}


+ (NSDate*)multiScenFixedDate:(MultiScenarioInputValue*)multiScenDate
{
	assert(multiScenDate != nil);
	SimDate *simDate = (SimDate*)[multiScenDate getValueForCurrentOrDefaultScenario];
	assert(simDate != nil);
	assert(simDate.date != nil);
	return simDate.date;
}

+ (double)multiScenFixedVal:(MultiScenarioInputValue*)multiScenVal
{
	assert(multiScenVal != nil);
	FixedValue *fixedVal = (FixedValue*)[multiScenVal getValueForCurrentOrDefaultScenario];
	assert(fixedVal != nil);
	assert(fixedVal.value != nil);
	return [fixedVal.value doubleValue];
}

+ (bool)multiScenBoolVal:(MultiScenarioInputValue*)multiScenBool
{
	assert(multiScenBool != nil);
	BoolInputValue *boolVal = (BoolInputValue*)[multiScenBool getValueForCurrentOrDefaultScenario];
	assert(boolVal != nil);
	assert(boolVal.isTrue != nil);
	bool theVal = [boolVal.isTrue boolValue];
	return theVal;
}




@end
