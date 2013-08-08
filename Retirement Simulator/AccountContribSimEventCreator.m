//
//  SavingsContributionSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountContribSimEventCreator.h"
#import "SimDate.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "DateHelper.h"
#import "VariableRateCalculator.h"
#import "EventRepeatFrequency.h"
#import "ValueAsOfCalculatorCreator.h"
#import "SharedAppValues.h"
#import "EventRepeater.h"
#import "Account.h"
#import "AccountContribSimEvent.h"
#import "InterestBearingWorkingBalance.h"
#import "MultiScenarioInputValue.h"
#import "MultiScenarioAmount.h"
#import "MultiScenarioGrowthRate.h"
#import "MultiScenarioSimDate.h"
#import "MultiScenarioSimEndDate.h"
#import "AccountSimInfo.h"
#import "SimParams.h"


@implementation AccountContribSimEventCreator

@synthesize acctSimInfo;
@synthesize varRateCalc;
@synthesize varAmountCalc;

@synthesize eventRepeater;


- (id)initWithAcctSimInfo:(AccountSimInfo*)theAcctSimInfo
{
	self = [super init];
	if(self)
	{
		self.acctSimInfo = theAcctSimInfo;
	
		DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		   [[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];

		DateSensitiveValue *amountGrowthRate = (DateSensitiveValue*)[
			self.acctSimInfo.account.contribGrowthRate.growthRate
			getValueForCurrentOrDefaultScenario];
		
		self.varRateCalc = [calcCreator 
							createForDateSensitiveValue:amountGrowthRate 
							andStartDate:self.acctSimInfo.simParams.simStartDate];
							
		DateSensitiveValue *amount = (DateSensitiveValue*)[self.acctSimInfo.account.contribAmount.amount 
				getValueForCurrentOrDefaultScenario];					
		ValueAsOfCalculatorCreator *varAmountCalcCreator = 
			[[[ValueAsOfCalculatorCreator alloc] init] autorelease];
		self.varAmountCalc = [varAmountCalcCreator createForDateSensitiveValue:amount];

	}
	return self;

}


- (void)resetSimEventCreation
{

	SimDate *startDate = (SimDate*)[self.acctSimInfo.account.contribStartDate.simDate 
			getValueForCurrentOrDefaultScenario];
	NSDate *resolvedStartDate = startDate.date;
			
	SimDate *endDate = (SimDate*)[self.acctSimInfo.account.contribEndDate.simDate 
			getValueForCurrentOrDefaultScenario];
	NSDate *resolvedEndDate = [endDate endDateWithStartDate:resolvedStartDate];
	
	NSLog(@"Savings contribution: start = %@, end = %@",
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:resolvedStartDate],
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:resolvedEndDate]);

	EventRepeatFrequency *repeatFreq = (EventRepeatFrequency*)
		[self.acctSimInfo.account.contribRepeatFrequency getValueForCurrentOrDefaultScenario];
	// TODO - Need to pass in an end date to the event repeat frequency
    self.eventRepeater = [[[EventRepeater alloc] 
                     initWithEventRepeatFrequency:repeatFreq 
                     andStartDate:resolvedStartDate andEndDate:resolvedEndDate] autorelease];
   
}

- (SimEvent*)nextSimEvent
{
    assert(eventRepeater!=nil);
	
    NSDate *nextDate = [eventRepeater nextDateOnOrAfterDate:self.acctSimInfo.simParams.simStartDate];
    if(nextDate !=nil)
    {
		
		double amountMultiplier = [self.varRateCalc valueMultiplierForDate:nextDate];
		double unadjustedAmount = [self.varAmountCalc valueAsOfDate:nextDate];
		double growthAdjustedContributionAmount = unadjustedAmount * amountMultiplier;
		
		AccountContribSimEvent *contribEvent = [[[AccountContribSimEvent alloc]initWithEventCreator:self 
			andEventDate:nextDate ] autorelease];
		contribEvent.acctSimInfo = self.acctSimInfo;
		contribEvent.contributionAmount = growthAdjustedContributionAmount;
        contribEvent.tieBreakPriority = SIM_EVENT_TIE_BREAK_PRIORITY_ACCT_CONTRIB;

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
	[eventRepeater release];
	[varRateCalc release];
	[varAmountCalc release];
	[acctSimInfo release];
    [super dealloc]; // pretty important.
}

@end
