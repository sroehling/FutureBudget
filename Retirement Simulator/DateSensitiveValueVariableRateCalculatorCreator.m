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
#import "VariableDate.h"
#import "DateSensitiveValueChange.h"
#import "DateHelper.h"

@implementation DateSensitiveValueVariableRateCalculatorCreator

@synthesize varRates;
@synthesize startDate;

- (VariableRateCalculator*)createForDateSensitiveValue:(DateSensitiveValue*)dsVal 
	andStartDate:(NSDate*)theStartDate;
{
	self.varRates = [[[NSMutableSet alloc] init] autorelease];
	self.startDate = theStartDate;
	
	[dsVal acceptDateSensitiveValVisitor:self];
	
	assert([self.varRates count] > 0);
	
	VariableRateCalculator *rateCalc = 
		[[[VariableRateCalculator alloc] initWithRates:varRates] autorelease];

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
	[self.varRates addObject:[[[VariableRate alloc] 
		initWithAnnualRate:annualRate andDaysSinceStart:0]autorelease]];
		
	for(DateSensitiveValueChange *valChange in variableVal.valueChanges)
	{
		NSTimeInterval secondsSinceStart = [valChange.startDate.date timeIntervalSinceDate:self.startDate];
		// TBD - is the right to not include values which come before the start date? Or
		// Should the startingvalue come before all other values, meaning a variable
		// value could be in effect at the start date.
		if(secondsSinceStart >= 0.0)
		{
			unsigned int daysSinceStart = floor(secondsSinceStart/SECONDS_PER_DAY);
			annualRate = [valChange.newValue doubleValue]/100.0;
			[self.varRates addObject:[[[VariableRate alloc] 
					initWithAnnualRate:annualRate andDaysSinceStart:daysSinceStart]autorelease]];
			
		}
	}

}

- (void) dealloc
{
	[super dealloc];
	[varRates release];
	[startDate release];
}

@end
