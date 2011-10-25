//
//  SavingsWorkingBalance.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InterestBearingWorkingBalance.h"
#import "SavingsAccount.h"
#import "SharedAppValues.h"
#import "DateSensitiveValue.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "MultiScenarioInputValue.h"
#import "BalanceAdjustment.h"
#import "VariableRateCalculator.h"
#import "SimInputHelper.h"
#import "DateHelper.h"
#import "MultiScenarioGrowthRate.h"
#import "SimParams.h"

@implementation InterestBearingWorkingBalance

@synthesize interestRateCalc;
@synthesize workingBalanceName;

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
	}
	return self;

}

- (id) initWithSavingsAcct:(SavingsAccount*)theSavingsAcct andSimParams:(SimParams*)simParams
{

	DateSensitiveValue *savingsInterestRate = (DateSensitiveValue*)[
			theSavingsAcct.interestRate.growthRate
			getValueForCurrentOrDefaultScenario];
	
	double acctWithdrawPriority = 
		[SimInputHelper multiScenFixedVal:theSavingsAcct.withdrawalPriority 
				andScenario:simParams.simScenario];
	double acctStartingBalance = [SimInputHelper doubleVal:theSavingsAcct.startingBalance];

	return [self initWithStartingBalance:acctStartingBalance 
		andInterestRate:savingsInterestRate andWorkingBalanceName:theSavingsAcct.name 
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


- (BalanceAdjustment*)advanceCurrentBalanceToDate:(NSDate*)newDate
{
	assert(newDate != nil);
	assert([DateHelper dateIsEqualOrLater:newDate otherDate:self.currentBalanceDate]);

	double balanceMultiplier = [self.interestRateCalc 
		valueMultiplierBetweenStartDate:self.currentBalanceDate andEndDate:newDate];
	
	double newBalance = currentBalance * balanceMultiplier;
	double interestAmount = newBalance - currentBalance;
	
	BalanceAdjustment *interest = [[[BalanceAdjustment alloc] 
		initWithAmount:interestAmount] autorelease];
	
	currentBalance = newBalance;
	self.currentBalanceDate = newDate;
	
	return interest;
}


- (NSString*)balanceName
{
	return self.workingBalanceName;
}


- (void) dealloc
{
	[super dealloc];
	[interestRateCalc release];
	[workingBalanceName release];
}


@end
