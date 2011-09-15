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
#import "InterestBearingWorkingBalance.h"
#import "MultiScenarioInputValue.h"


@implementation SavingsContributionSimEventCreator

@synthesize savingsWorkingBalance;
@synthesize varRateCalc;
@synthesize varAmountCalc;
@synthesize savingsAcct;
@synthesize eventRepeater;

- (id)initWithSavingsWorkingBalance:(InterestBearingWorkingBalance*)theWorkingBalance
	andSavingsAcct:(SavingsAccount*)theSavingsAcct;
{
	self = [super init];
	if(self)
	{
		self.savingsWorkingBalance = theWorkingBalance;
	
		self.savingsAcct = theSavingsAcct;
		assert(savingsAcct != nil);


		DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		   [[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];

		DateSensitiveValue *amountGrowthRate = (DateSensitiveValue*)[
			savingsAcct.multiScenarioContribGrowthRate
			getValueForCurrentOrDefaultScenario];
		
		self.varRateCalc = [calcCreator 
							createForDateSensitiveValue:amountGrowthRate 
							andStartDate:[[SharedAppValues singleton] beginningOfSimStartDate]];
							
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

	SimDate *startDate = (SimDate*)[self.savingsAcct.multiScenarioContribStartDate 
			getValueForCurrentOrDefaultScenario];
	NSDate *resolvedStartDate = startDate.date;
			
	SimDate *endDate = (SimDate*)[self.savingsAcct.multiScenarioContribEndDate 
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
		
		double amountMultiplier = [self.varRateCalc valueMultiplierForDate:nextDate];
		double unadjustedAmount = [self.varAmountCalc valueAsOfDate:nextDate];
		double growthAdjustedContributionAmount = unadjustedAmount * amountMultiplier;
		
		SavingsContributionSimEvent *contribEvent = [[[SavingsContributionSimEvent alloc]initWithEventCreator:self 
			andEventDate:nextDate ] autorelease];
		contribEvent.savingsBalance = self.savingsWorkingBalance;
		contribEvent.contributionAmount = growthAdjustedContributionAmount;
		contribEvent.contributionIsTaxable = [self.savingsAcct.taxableContributions boolValue];

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
	[varAmountCalc release];
}

@end
