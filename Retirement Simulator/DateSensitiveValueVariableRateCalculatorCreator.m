//
//  DateSensitiveValueVariableRateCalculatorCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "DateSensitiveValueVisitor.h"
#import "DateSensitiveValue.h"
#import "VariableRateCalculator.h"
#import "VariableRate.h"
#import "FixedValue.h"
#import "VariableValue.h"
#import "SimDate.h"
#import "DateSensitiveValueChange.h"
#import "DateHelper.h"
#import "IntermediateVariableRate.h"
#import "CollectionHelper.h"
#import "MultiScenarioInputValue.h"

@implementation DateSensitiveValueVariableRateCalculatorCreator

@synthesize varRates;
@synthesize startDate;

- (VariableRateCalculator*)createForDateSensitiveValue:(DateSensitiveValue*)dsVal 
	andStartDate:(NSDate*)theStartDate;
{
	self.varRates = [[[NSMutableSet alloc] init] autorelease];
	self.startDate = theStartDate;
	assert(dsVal != nil);
	
	[dsVal acceptDateSensitiveValVisitor:self];
	
	assert([self.varRates count] > 0);
	
	VariableRateCalculator *rateCalc = 
		[[[VariableRateCalculator alloc] initWithRates:varRates andStartDate:theStartDate] autorelease];

	return rateCalc;
}

- (void)visitFixedValue:(FixedValue*)fixedVal
{
	double annualRate = [fixedVal.value doubleValue]/100.0;
	[self.varRates addObject:[[[VariableRate alloc] 
		initWithAnnualRate:annualRate andDaysSinceStart:0]autorelease]];
}



- (void)visitVariableValue:(VariableValue*)variableVal
{
	double annualRate = [variableVal.startingValue doubleValue]/100.0;
	
	NSMutableSet *intermediateRates = [[[NSMutableSet alloc] init] autorelease];
	
	[intermediateRates addObject:[[[IntermediateVariableRate alloc] initWithAnnualRate:annualRate andSecondsVsStart:NSIntegerMin] autorelease]];
	
	for(DateSensitiveValueChange *valChange in variableVal.valueChanges)
	{
		NSTimeInterval secondsVsStart = [valChange.startDate.date timeIntervalSinceDate:self.startDate];
		annualRate = [valChange.newValue doubleValue]/100.0;
		[intermediateRates addObject:[[[IntermediateVariableRate alloc]
			initWithAnnualRate:annualRate andSecondsVsStart:secondsVsStart] autorelease]];		
	}
	
	NSArray *sortedIntermediateRates = [CollectionHelper 
		setToSortedArray:intermediateRates 
		withKey:INTERMEDIATE_VARIABLE_RATE_SECONDS_VS_START_KEY];
		
	NSEnumerator *intermedRateEnum = [sortedIntermediateRates objectEnumerator];
	IntermediateVariableRate *intRate = (IntermediateVariableRate *)[intermedRateEnum nextObject];
	assert(intRate!=nil);
	IntermediateVariableRate *firstRate = intRate;
	while((intRate != nil) && (intRate.secondsVsStart <= 0))
	{
		firstRate = intRate;
		intRate = (IntermediateVariableRate *)[intermedRateEnum nextObject];
	}
	[self.varRates addObject:[[[VariableRate alloc] 
			initWithAnnualRate:firstRate.annualRate andDaysSinceStart:0]autorelease]];
			
	while(intRate != nil)
	{
		assert(intRate.secondsVsStart > 0);
		double currentAnnualRate = intRate.annualRate;
		unsigned int currDaysSinceStart = floor(intRate.secondsVsStart/SECONDS_PER_DAY);
		
		intRate = (IntermediateVariableRate *)[intermedRateEnum nextObject];
		
		if(intRate == nil)
		{
			[self.varRates addObject:[[[VariableRate alloc] 
					initWithAnnualRate:currentAnnualRate 
					andDaysSinceStart:currDaysSinceStart]autorelease]];
		}
		else
		{
			unsigned int nextDaysSinceStart = floor(intRate.secondsVsStart/SECONDS_PER_DAY);
			if(nextDaysSinceStart > currDaysSinceStart)
			{
				[self.varRates addObject:[[[VariableRate alloc] 
					initWithAnnualRate:currentAnnualRate 
					andDaysSinceStart:currDaysSinceStart]autorelease]];

			}
		}
	}		

	

}

+(VariableRateCalculator*)createVariableRateCalc:(MultiScenarioInputValue*)multiScenDateSensitiveVal
	andStartDate:(NSDate*)calcStartDate
{
	DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		   [[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];
	DateSensitiveValue *dateSensitiveVal = (DateSensitiveValue*)[
				multiScenDateSensitiveVal getValueForCurrentOrDefaultScenario];
	assert(dateSensitiveVal != nil);
	VariableRateCalculator *rateCalc = [calcCreator 
							createForDateSensitiveValue:dateSensitiveVal 
							andStartDate:calcStartDate];
	return rateCalc;

}


- (void) dealloc
{
	[super dealloc];
	[varRates release];
	[startDate release];
}

@end
