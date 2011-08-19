//
//  ExpenseInputSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CashFlowSimEventCreator.h"

#import "ExpenseInput.h"
#import "EventRepeater.h"
#import "SharedAppValues.h"
#import "CashFlowInput.h"
#import "SimDate.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "DateHelper.h"
#import "VariableRateCalculator.h"
#import "ValueAsOfCalculatorCreator.h"
#import "MultiScenarioInputValue.h"

@protocol SimEventCreator;

@implementation CashFlowSimEventCreator

@synthesize cashFlow;
@synthesize varRateCalc;
@synthesize startAmountGrowthDate;
@synthesize varAmountCalc;
@synthesize eventRepeater;

- (id)initWithCashFlow:(CashFlowInput*)theCashFlow
{
    self = [super init];
    if(self)
    {
        assert(theCashFlow != nil);
        self.cashFlow = theCashFlow;
			
		SimDate *startDate = (SimDate*)[theCashFlow.multiScenarioStartDate 
			getValueForCurrentOrDefaultScenario];
	
		self.startAmountGrowthDate = startDate.date;

		DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		   [[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];

		DateSensitiveValue *amountGrowthRate = (DateSensitiveValue*)[self.cashFlow.multiScenarioAmountGrowthRate
			getValueForCurrentOrDefaultScenario];
		
		self.varRateCalc = [calcCreator 
							createForDateSensitiveValue:amountGrowthRate 
							andStartDate:self.startAmountGrowthDate];
							
		DateSensitiveValue *amount = (DateSensitiveValue*)[self.cashFlow.multiScenarioAmount 
				getValueForCurrentOrDefaultScenario];					
		ValueAsOfCalculatorCreator *varAmountCalcCreator = 
			[[[ValueAsOfCalculatorCreator alloc] init] autorelease];
		self.varAmountCalc = [varAmountCalcCreator createForDateSensitiveValue:amount];
							
    }
    return self;
}

- (id) init 
{
	assert(0); // need to call init with cashFlow
	return nil;
}



- (void)resetSimEventCreation
{
	SimDate *startDate = (SimDate*)[self.cashFlow.multiScenarioStartDate 
			getValueForCurrentOrDefaultScenario];
	NSDate *resolvedStartDate = startDate.date;
			
	SimDate *endDate = (SimDate*)[self.cashFlow.multiScenarioEndDate 
			getValueForCurrentOrDefaultScenario];
	NSDate *resolvedEndDate = [endDate endDateWithStartDate:resolvedStartDate];

	EventRepeatFrequency *repeatFreq = (EventRepeatFrequency*)
		[self.cashFlow.multiScenarioEventRepeatFrequency getValueForCurrentOrDefaultScenario];
    self.eventRepeater = [[EventRepeater alloc] 
                     initWithEventRepeatFrequency:repeatFreq 
                     andStartDate:resolvedStartDate andEndDate:resolvedEndDate];
   
}

- (SimEvent*) createCashFlowSimEvent:(double)cashFlowAmount andEventDate:(NSDate*)theDate
{
	assert(0); // must be overridden
}


- (SimEvent*)nextSimEvent
{
    assert(eventRepeater!=nil);
    NSDate *nextDate = [eventRepeater nextDateOnOrAfterDate:[[SharedAppValues singleton] beginningOfSimStartDate]];
    if(nextDate !=nil)
    {
		
		NSTimeInterval secondsSinceAmountGrowth = [nextDate timeIntervalSinceDate:self.startAmountGrowthDate];
		// TBD - is the right to not include values which come before the start date? Or
		// Should the startingvalue come before all other values, meaning a variable
		// value could be in effect at the start date.
		assert(secondsSinceAmountGrowth >= 0.0);
		unsigned int daysSinceStart = floor(secondsSinceAmountGrowth/SECONDS_PER_DAY);
		double amountMultiplier = [self.varRateCalc valueMultiplierForDay:daysSinceStart];
		double unadjustedAmount = [self.varAmountCalc valueAsOfDate:nextDate];
		double growthAdjustedCashFlowAmount = unadjustedAmount * amountMultiplier;
		
		return [self createCashFlowSimEvent:growthAdjustedCashFlowAmount andEventDate:nextDate];
       
    }
    else
    {
        // TBD - Is this good objective C style to return nil for governing control flow
        return nil;
    }
}

- (void)dealloc {
    // release owned objects here
    [super dealloc]; // pretty important.
	[eventRepeater release];
	[varRateCalc release];
	[startAmountGrowthDate release];
	[varAmountCalc release];
}


@end
