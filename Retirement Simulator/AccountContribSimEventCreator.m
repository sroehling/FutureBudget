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


@implementation AccountContribSimEventCreator

@synthesize acctWorkingBalance;
@synthesize varRateCalc;
@synthesize varAmountCalc;
@synthesize account;
@synthesize eventRepeater;
@synthesize simStartDate;

- (id)initWithWorkingBalance:(InterestBearingWorkingBalance*)theWorkingBalance
	andAcct:(Account*)theAcct andSimStartDate:(NSDate*)simStart
{
	self = [super init];
	if(self)
	{
		self.acctWorkingBalance = theWorkingBalance;
	
		self.account = theAcct;
		assert(theAcct != nil);

		self.simStartDate = simStart;

		DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		   [[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];

		DateSensitiveValue *amountGrowthRate = (DateSensitiveValue*)[
			account.contribGrowthRate.growthRate
			getValueForCurrentOrDefaultScenario];
		
		self.varRateCalc = [calcCreator 
							createForDateSensitiveValue:amountGrowthRate 
							andStartDate:simStart];
							
		DateSensitiveValue *amount = (DateSensitiveValue*)[account.contribAmount.amount 
				getValueForCurrentOrDefaultScenario];					
		ValueAsOfCalculatorCreator *varAmountCalcCreator = 
			[[[ValueAsOfCalculatorCreator alloc] init] autorelease];
		self.varAmountCalc = [varAmountCalcCreator createForDateSensitiveValue:amount];

	}
	return self;
}


- (void)resetSimEventCreation
{

	SimDate *startDate = (SimDate*)[self.account.contribStartDate.simDate 
			getValueForCurrentOrDefaultScenario];
	NSDate *resolvedStartDate = startDate.date;
			
	SimDate *endDate = (SimDate*)[self.account.contribEndDate.simDate 
			getValueForCurrentOrDefaultScenario];
	NSDate *resolvedEndDate = [endDate endDateWithStartDate:resolvedStartDate];
	
	NSLog(@"Savings contribution: start = %@, end = %@",
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:resolvedStartDate],
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:resolvedEndDate]);

	EventRepeatFrequency *repeatFreq = (EventRepeatFrequency*)
		[account.contribRepeatFrequency getValueForCurrentOrDefaultScenario];
	// TODO - Need to pass in an end date to the event repeat frequency
    self.eventRepeater = [[EventRepeater alloc] 
                     initWithEventRepeatFrequency:repeatFreq 
                     andStartDate:resolvedStartDate andEndDate:resolvedEndDate];
   
}

- (SimEvent*)nextSimEvent
{
    assert(eventRepeater!=nil);
	
    NSDate *nextDate = [eventRepeater nextDateOnOrAfterDate:self.simStartDate];
    if(nextDate !=nil)
    {
		
		double amountMultiplier = [self.varRateCalc valueMultiplierForDate:nextDate];
		double unadjustedAmount = [self.varAmountCalc valueAsOfDate:nextDate];
		double growthAdjustedContributionAmount = unadjustedAmount * amountMultiplier;
		
		AccountContribSimEvent *contribEvent = [[[AccountContribSimEvent alloc]initWithEventCreator:self 
			andEventDate:nextDate ] autorelease];
		contribEvent.acctBalance = self.acctWorkingBalance;
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
	[acctWorkingBalance release];
	[eventRepeater release];
	[varRateCalc release];
	[varAmountCalc release];
	[account release];
	[simStartDate release];
}

@end
