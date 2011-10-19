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
#import "MultiScenarioAmount.h"
#import "MultiScenarioGrowthRate.h"
#import "MultiScenarioSimDate.h"
#import "MultiScenarioSimEndDate.h"

@protocol SimEventCreator;

@implementation CashFlowSimEventCreator

@synthesize cashFlow;
@synthesize varRateCalc;
@synthesize varAmountCalc;
@synthesize eventRepeater;

- (id)initWithCashFlow:(CashFlowInput*)theCashFlow
{
    self = [super init];
    if(self)
    {
        assert(theCashFlow != nil);
        self.cashFlow = theCashFlow;
	
		DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		   [[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];

		DateSensitiveValue *amountGrowthRate = (DateSensitiveValue*)[self.cashFlow.amountGrowthRate.growthRate
			getValueForCurrentOrDefaultScenario];
		
		self.varRateCalc = [calcCreator 
							createForDateSensitiveValue:amountGrowthRate 
							andStartDate:[[SharedAppValues singleton] beginningOfSimStartDate]];
							
		DateSensitiveValue *amount = (DateSensitiveValue*)[self.cashFlow.amount.amount 
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
	SimDate *startDate = (SimDate*)[self.cashFlow.startDate.simDate 
			getValueForCurrentOrDefaultScenario];
	NSDate *resolvedStartDate = startDate.date;
			
	SimDate *endDate = (SimDate*)[self.cashFlow.endDate.simDate 
			getValueForCurrentOrDefaultScenario];
	NSDate *resolvedEndDate = [endDate endDateWithStartDate:resolvedStartDate];

	EventRepeatFrequency *repeatFreq = (EventRepeatFrequency*)
		[self.cashFlow.eventRepeatFrequency getValueForCurrentOrDefaultScenario];
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
		
		double amountMultiplier = [self.varRateCalc valueMultiplierForDate:nextDate];
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
	[varAmountCalc release];
}


@end
