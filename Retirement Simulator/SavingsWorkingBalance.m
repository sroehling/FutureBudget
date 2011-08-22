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

@synthesize savingsAcct;
@synthesize interestRateCalc;

- (id) initWithSavingsAcct:(SavingsAccount*)theSavingsAcct
{
	double theStartBalance = [theSavingsAcct.startingBalance doubleValue];
	self = [super initWithStartingBalance:theStartBalance];
	if(self)
	{
		assert(theSavingsAcct != nil);
		self.savingsAcct = theSavingsAcct;
		
		
		DateSensitiveValue *savingsInterestRate = (DateSensitiveValue*)[
			savingsAcct.multiScenarioInterestRate
			getValueForCurrentOrDefaultScenario];
			
		DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		   [[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];
		
		self.interestRateCalc = [calcCreator 
							createForDateSensitiveValue:savingsInterestRate 
							andStartDate:[[SharedAppValues singleton] beginningOfSimStartDate]];

	}
	return self;
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

- (void) dealloc
{
	[super dealloc];
	[savingsAcct release];
	[interestRateCalc release];
}


@end
