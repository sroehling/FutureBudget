//
//  SimInputHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimInputHelper.h"

#import "MultiScenarioInputValue.h"
#import "MultiScenarioAmount.h"
#import "MultiScenarioGrowthRate.h"

#import "ValueAsOfCalculator.h"
#import "ValueAsOfCalculatorCreator.h"
#import "SimDate.h"
#import "BoolInputValue.h"
#import "FixedValue.h"
#import "DateHelper.h"
#import "VariableRateCalculator.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"

@implementation SimInputHelper

+ (double)doubleVal:(NSNumber*)numberVal
{
	assert(numberVal != nil);
	double theVal = [numberVal doubleValue];
	return theVal;
}

+ (double)multiScenValueAsOfDate:(MultiScenarioInputValue*)multiScenDateSensitiveVal
	andDate:(NSDate*)resolveDate andScenario:(Scenario*)theScenario
{
	assert(resolveDate != nil);
	id<ValueAsOfCalculator> amtCalc = [ValueAsOfCalculatorCreator createValueAsOfCalc:multiScenDateSensitiveVal
		andScenario:theScenario];
	double valAsOfDate = [amtCalc valueAsOfDate:resolveDate];
	return valAsOfDate;

}

+(BOOL)isValidAsOfDate:(NSDate*)asOfDate vsStartDate:(NSDate*)startDate
{
    DateHelper *helperForValidityCheck = [[[DateHelper alloc] init] autorelease];
    
    return [helperForValidityCheck dateIsEqualOrLater:asOfDate otherDate:startDate];
}

+ (double)multiScenVariableRateMultiplier:(MultiScenarioInputValue*)multiScenDateSensitiveVal
	sinceStartDate:(NSDate*)startDate asOfDate:(NSDate*)asOfDate andScenario:(Scenario*)theScenario
{
	assert(asOfDate != nil);
	assert(startDate != nil);
	assert([SimInputHelper isValidAsOfDate:asOfDate vsStartDate:startDate]);
	assert(multiScenDateSensitiveVal != nil);

	VariableRateCalculator *rateCalc = [DateSensitiveValueVariableRateCalculatorCreator
		createVariableRateCalc:multiScenDateSensitiveVal
		andStartDate:startDate andScenario:theScenario andUseLoanAnnualRates:false];
	return [rateCalc valueMultiplierForDate:asOfDate];

}

+(double)multiScenRateAdjustedValueAsOfDate:(MultiScenarioInputValue*)multiScenAmount
	andMultiScenRate:(MultiScenarioInputValue*)multiScenGrowthRate 
	asOfDate:(NSDate*)asOfDate sinceDate:(NSDate*)startDate
	forScenario:(Scenario*)theScenario
{
	assert(theScenario != nil);
	assert(startDate != nil);
	assert(asOfDate != nil);
	assert([SimInputHelper isValidAsOfDate:asOfDate vsStartDate:startDate]);
	assert(multiScenGrowthRate != nil);
	assert(multiScenAmount != nil);

	double unadjustedAmount = [SimInputHelper multiScenValueAsOfDate:multiScenAmount 
			andDate:asOfDate andScenario:theScenario];

	double amountMultiplier = [SimInputHelper multiScenVariableRateMultiplier:multiScenGrowthRate 
		sinceStartDate:startDate 
			asOfDate:asOfDate andScenario:theScenario];
		
	double adjustedAmount = unadjustedAmount * amountMultiplier;
			
	return adjustedAmount;
}

+(double)multiScenRateAdjustedAmount:(MultiScenarioAmount*)multiScenAmount
	andMultiScenRate:(MultiScenarioGrowthRate*)growthRate asOfDate:(NSDate *)asOfDate 
	sinceDate:(NSDate *)startDate forScenario:(Scenario *)theScenario
{
	
	return [SimInputHelper multiScenRateAdjustedValueAsOfDate:multiScenAmount.amount 
	andMultiScenRate:growthRate.growthRate asOfDate:asOfDate sinceDate:startDate forScenario:theScenario];

}


+ (NSDate*)multiScenFixedDate:(MultiScenarioInputValue*)multiScenDate andScenario:(Scenario*)theScenario
{
	assert(multiScenDate != nil);
	SimDate *simDate = (SimDate*)[multiScenDate getValueForScenarioOrDefault:theScenario];
	assert(simDate != nil);
	assert(simDate.date != nil);
	return simDate.date;
}

+(NSDate*)multiScenEndDate:(MultiScenarioInputValue*)multiScenEndDate 
	withStartDate:(MultiScenarioInputValue*)theStartDate
	andScenario:(Scenario*)theScenario
{
	assert(theScenario != nil);
	
	NSDate *startDate = [SimInputHelper multiScenFixedDate:theStartDate andScenario:theScenario];

	assert(multiScenEndDate != nil);
	SimDate *endSimDate = (SimDate*)[multiScenEndDate getValueForScenarioOrDefault:theScenario];
	assert(endSimDate != nil);
	
	NSDate *endDate = [endSimDate endDateWithStartDate:startDate];
	return endDate;
}

+ (double)multiScenFixedVal:(MultiScenarioInputValue*)multiScenVal andScenario:(Scenario*)theScenario
{
	assert(multiScenVal != nil);
	FixedValue *fixedVal = (FixedValue*)[multiScenVal getValueForScenarioOrDefault:theScenario];
	assert(fixedVal != nil);
	assert(fixedVal.value != nil);
	return [fixedVal.value doubleValue];
}

+ (bool)multiScenBoolVal:(MultiScenarioInputValue*)multiScenBool andScenario:(Scenario*)theScenario
{
	assert(multiScenBool != nil);
	BoolInputValue *boolVal = (BoolInputValue*)[multiScenBool getValueForScenarioOrDefault:theScenario];
	assert(boolVal != nil);
	assert(boolVal.isTrue != nil);
	bool theVal = [boolVal.isTrue boolValue];
	return theVal;
}




@end
