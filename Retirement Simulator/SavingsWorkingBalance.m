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
#import "BalanceAdjustment.h"
#import "VariableRateCalculator.h"
#import "DateHelper.h"

@implementation SavingsWorkingBalance

@synthesize interestRateCalc;
@synthesize workingBalanceName;
@synthesize taxableWithdrawals;
@synthesize taxableInterest;


- (id) initWithStartingBalance:(double)theStartBalance
	andInterestRate:(DateSensitiveValue*)theInterestRate
	andWorkingBalanceName:(NSString*)wbName
	andStartDate:(NSDate*)theStartDate
	andTaxWithdrawals:(bool)doTaxWithdrawals
	andTaxInterest:(bool)doTaxInterest
{
	self = [super initWithStartingBalance:theStartBalance 
		andStartDate:theStartDate];
	{
		DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		   [[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];
		
		self.interestRateCalc = [calcCreator 
							createForDateSensitiveValue:theInterestRate 
							andStartDate:theStartDate];
							
		taxableWithdrawals = doTaxWithdrawals;
		taxableInterest = doTaxInterest;
		
							
		self.workingBalanceName = wbName;
	}
	return self;

}

- (id) initWithSavingsAcct:(SavingsAccount*)theSavingsAcct
{

	DateSensitiveValue *savingsInterestRate = (DateSensitiveValue*)[
			theSavingsAcct.multiScenarioInterestRate
			getValueForCurrentOrDefaultScenario];

	bool doTaxWithdrawals = [theSavingsAcct.taxableWithdrawals boolValue];
	bool doTaxInterest = [theSavingsAcct.taxableInterest boolValue];

	return [self initWithStartingBalance:[theSavingsAcct.startingBalance doubleValue] andInterestRate:savingsInterestRate andWorkingBalanceName:theSavingsAcct.name 
		andStartDate:[[SharedAppValues singleton] beginningOfSimStartDate]
		andTaxWithdrawals:doTaxWithdrawals andTaxInterest:doTaxInterest];
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
		initWithAmount:interestAmount 
		andIsAmountTaxable:self.taxableInterest] autorelease];
	
	currentBalance = newBalance;
	self.currentBalanceDate = newDate;
	
	return interest;
}

- (bool)doTaxWithdrawals
{
	return self.taxableWithdrawals;
}

- (bool)doTaxInterest
{
	return self.taxableInterest;
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
