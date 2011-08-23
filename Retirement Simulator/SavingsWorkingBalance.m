//
//  SavingsWorkingBalance.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavingsWorkingBalance.h"
#import "SavingsAccount.h"
#import "SharedAppValues.h"
#import "DateSensitiveValue.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "MultiScenarioInputValue.h"
#import "VariableRateCalculator.h"

@implementation SavingsWorkingBalance

@synthesize interestRateCalc;
@synthesize workingBalanceName;


- (id) initWithStartingBalance:(double)theStartBalance
	andInterestRate:(DateSensitiveValue*)theInterestRate
	andWorkingBalanceName:(NSString*)wbName
	andStartDate:(NSDate*)theStartDate
{
	self = [super initWithStartingBalance:theStartBalance 
		andStartDate:theStartDate];
	{
		DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		   [[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];
		
		self.interestRateCalc = [calcCreator 
							createForDateSensitiveValue:theInterestRate 
							andStartDate:theStartDate];
							
		self.workingBalanceName = wbName;
	}
	return self;

}

- (id) initWithSavingsAcct:(SavingsAccount*)theSavingsAcct
{

	DateSensitiveValue *savingsInterestRate = (DateSensitiveValue*)[
			theSavingsAcct.multiScenarioInterestRate
			getValueForCurrentOrDefaultScenario];


	return [self initWithStartingBalance:[theSavingsAcct.startingBalance doubleValue] andInterestRate:savingsInterestRate andWorkingBalanceName:theSavingsAcct.name andStartDate:[[SharedAppValues singleton] beginningOfSimStartDate]];
}


- (id) initWithStartingBalance:(double)theStartBalance
{
	assert(0); // must init with savings acct
}

- (id) init 
{
	assert(0); // must init with savings acct
	
}

- (void)carryBalanceForward:(NSDate*)newStartDate
{
	// Calculate the multiplier ("carryForwardMultiplier") between 
	// currentBalanceDate and newStartDate
	assert(newStartDate != nil);
	double balanceMultiplier = [self.interestRateCalc valueMultiplierBetweenStartDate:self.currentBalanceDate andEndDate:newStartDate];
	
	[super carryBalanceForward:newStartDate];
	startingBalance = self.currentBalance *balanceMultiplier;
	currentBalance = startingBalance;
}

- (void)advanceCurrentBalanceToDate:(NSDate*)newDate
{	
	assert(newDate != nil);
	double balanceMultiplier = [self.interestRateCalc valueMultiplierBetweenStartDate:self.currentBalanceDate andEndDate:newDate];
	[super advanceCurrentBalanceToDate:newDate];
	currentBalance = currentBalance * balanceMultiplier;
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
