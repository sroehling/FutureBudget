//
//  SavingsWorkingBalance.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InterestBearingWorkingBalance.h"
#import "Account.h"
#import "SharedAppValues.h"
#import "DateSensitiveValue.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "MultiScenarioInputValue.h"
#import "VariableRateCalculator.h"
#import "SimInputHelper.h"
#import "DateHelper.h"
#import "MultiScenarioGrowthRate.h"
#import "InputValDigestSummation.h"
#import "SimParams.h"

@implementation InterestBearingWorkingBalance

@synthesize interestRateCalc;
@synthesize workingBalanceName;
@synthesize accruedInterest;

- (id) initWithStartingBalance:(double)theStartBalance 
	andInterestRateCalc:(VariableRateCalculator*)theInterestRateCalc 
	andWorkingBalanceName:(NSString *)wbName 
	andWithdrawPriority:(double)theWithdrawPriority
{
	self = [super initWithStartingBalance:theStartBalance 
			andStartDate:theInterestRateCalc.startDate andWithdrawPriority:theWithdrawPriority];
	if(self)
	{
		self.interestRateCalc = theInterestRateCalc;
		self.workingBalanceName = wbName;
		self.accruedInterest = [[[InputValDigestSummation alloc] init] autorelease];

	}
	return self;
}

- (id) initWithStartingBalance:(double)theStartBalance
	andInterestRate:(DateSensitiveValue*)theInterestRate
	andWorkingBalanceName:(NSString*)wbName
	andStartDate:(NSDate*)theStartDate
	andWithdrawPriority:(double)theWithdrawPriority
{
	self = [super initWithStartingBalance:theStartBalance 
		andStartDate:theStartDate andWithdrawPriority:theWithdrawPriority];
	if(self) {
		DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		   [[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];
		
		self.interestRateCalc = [calcCreator 
							createForDateSensitiveValue:theInterestRate 
							andStartDate:theStartDate];
		self.workingBalanceName = wbName;
		self.accruedInterest = [[[InputValDigestSummation alloc] init] autorelease];
	}
	return self;

}

- (id) initWithAcct:(Account*)theAcct andSimParams:(SimParams*)simParams
{

	DateSensitiveValue *savingsInterestRate = (DateSensitiveValue*)[
			theAcct.interestRate.growthRate
			getValueForCurrentOrDefaultScenario];
	
	double acctWithdrawPriority = 
		[SimInputHelper multiScenFixedVal:theAcct.withdrawalPriority 
				andScenario:simParams.simScenario];
	assert(theAcct.startingBalance != nil);
	double acctStartingBalance = [SimInputHelper doubleVal:theAcct.startingBalance];

	return [self initWithStartingBalance:acctStartingBalance 
		andInterestRate:savingsInterestRate andWorkingBalanceName:theAcct.name 
		andStartDate:simParams.simStartDate 
		andWithdrawPriority:acctWithdrawPriority];
}


- (id) initWithStartingBalance:(double)theStartBalance
{
	assert(0); // must init with savings acct
}

- (id) init 
{
	assert(0); // must init with savings acct
	
}


- (void)advanceCurrentBalanceToDate:(NSDate*)newDate
{
	assert(newDate != nil);
	
	// Advancing to the current date is a no-op if the newDate is before the current date.
	// If the current date is in the future, then this working balance is typically for 
	// an input such as a loan or asset which is originated or purchased in the future. 
	if([DateHelper dateIsLater:newDate otherDate:self.currentBalanceDate])
	{
		double balanceMultiplier = [self.interestRateCalc 
			valueMultiplierBetweenStartDate:self.currentBalanceDate andEndDate:newDate];
		
		double newBalance = currentBalance * balanceMultiplier;
		double interestAmount = newBalance - currentBalance;
		
		NSUInteger dayIndex = [DateHelper daysOffset:newDate vsEarlierDate:self.balanceStartDate];
		[self.accruedInterest adjustSum:interestAmount onDay:dayIndex];

		currentBalance = newBalance;
		self.currentBalanceDate = newDate;
	}
}


- (NSString*)balanceName
{
	return self.workingBalanceName;
}


- (void) dealloc
{
	[interestRateCalc release];
	[workingBalanceName release];
	[accruedInterest release];
	[super dealloc];
}


@end
