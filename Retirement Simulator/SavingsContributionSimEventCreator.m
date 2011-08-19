//
//  SavingsContributionSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavingsContributionSimEventCreator.h"
#import "SimDate.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "DateHelper.h"
#import "VariableRateCalculator.h"
#import "EventRepeatFrequency.h"
#import "ValueAsOfCalculatorCreator.h"
#import "SharedAppValues.h"
#import "EventRepeater.h"
#import "SavingsAccount.h"
#import "SavingsContributionSimEvent.h"
#import "SavingsWorkingBalance.h"
#import "MultiScenarioInputValue.h"


@implementation SavingsContributionSimEventCreator

@synthesize savingsWorkingBalance;
@synthesize varRateCalc;
@synthesize startAmountGrowthDate;
@synthesize varAmountCalc;
@synthesize eventRepeater;

- (id)initWithSavingsWorkingBalance:(SavingsWorkingBalance*)theWorkingBalance
{
	self = [super init];
	if(self)
	{
		self.savingsWorkingBalance = theWorkingBalance;
	
		SavingsAccount *savingsAcct = self.savingsWorkingBalance.savingsAcct;
		assert(savingsAcct != nil);

		SimDate *startDate = (SimDate*)[savingsAcct.multiScenarioContribStartDate
			getValueForCurrentOrDefaultScenario];
	
#warning Probably need to use simulator start date as the start rate for growth rates, rather than the first date of the event.
		self.startAmountGrowthDate = startDate.date;

		DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		   [[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];

		DateSensitiveValue *amountGrowthRate = (DateSensitiveValue*)[
			savingsAcct.multiScenarioContribGrowthRate
			getValueForCurrentOrDefaultScenario];
		
		self.varRateCalc = [calcCreator 
							createForDateSensitiveValue:amountGrowthRate 
							andStartDate:self.startAmountGrowthDate];
							
		DateSensitiveValue *amount = (DateSensitiveValue*)[savingsAcct.multiScenarioContribAmount 
				getValueForCurrentOrDefaultScenario];					
		ValueAsOfCalculatorCreator *varAmountCalcCreator = 
			[[[ValueAsOfCalculatorCreator alloc] init] autorelease];
		self.varAmountCalc = [varAmountCalcCreator createForDateSensitiveValue:amount];

	}
	return self;
}


- (void)resetSimEventCreation
{

	SavingsAccount *savingsAcct = self.savingsWorkingBalance.savingsAcct;
	assert(savingsAcct != nil);

	SimDate *startDate = (SimDate*)[savingsAcct.multiScenarioContribStartDate 
			getValueForCurrentOrDefaultScenario];
	NSDate *resolvedStartDate = startDate.date;
			
	SimDate *endDate = (SimDate*)[savingsAcct.multiScenarioContribEndDate 
			getValueForCurrentOrDefaultScenario];
	NSDate *resolvedEndDate = [endDate endDateWithStartDate:resolvedStartDate];
	
	NSLog(@"Savings contribution: start = %@, end = %@",
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:resolvedStartDate],
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:resolvedEndDate]);

	EventRepeatFrequency *repeatFreq = (EventRepeatFrequency*)
		[savingsAcct.multiScenarioContribRepeatFrequency getValueForCurrentOrDefaultScenario];
	// TODO - Need to pass in an end date to the event repeat frequency
    self.eventRepeater = [[EventRepeater alloc] 
                     initWithEventRepeatFrequency:repeatFreq 
                     andStartDate:resolvedStartDate andEndDate:resolvedEndDate];
   
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
		double growthAdjustedContributionAmount = unadjustedAmount * amountMultiplier;
		
		SavingsContributionSimEvent *contribEvent = [[[SavingsContributionSimEvent alloc]initWithEventCreator:self 
			andEventDate:nextDate ] autorelease];
		contribEvent.savingsBalance = self.savingsWorkingBalance;
		contribEvent.contributionAmount = growthAdjustedContributionAmount;

		return contribEvent;
		       
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
	[savingsWorkingBalance release];
	[eventRepeater release];
	[varRateCalc release];
	[startAmountGrowthDate release];
	[varAmountCalc release];
}

@end
