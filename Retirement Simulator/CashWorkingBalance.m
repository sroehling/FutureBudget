//
//  CashWorkingBalance.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CashWorkingBalance.h"
#import "Cash.h"
#import "SharedAppValues.h"
#import "DateHelper.h"
#import "SharedAppValues.h"
#import "BalanceAdjustment.h"
#import "LocalizationHelper.h"

// Cash always has the highest priority for withdrawals.
#define CASH_WITHDRAW_PRIORITY -1.0

// TODO - Need to verify that all other priorities are >= 0.0

@implementation CashWorkingBalance

- (id) init
{
	Cash *theCash = [SharedAppValues singleton].cash;
	assert(theCash != nil);
	double startingCashBalance = [theCash.startingBalance doubleValue];
	
	NSDate *startDate = [DateHelper beginningOfDay:[SharedAppValues singleton].simStartDate];
	
	self = [super initWithStartingBalance:startingCashBalance andStartDate:startDate 
		andWithdrawPriority:CASH_WITHDRAW_PRIORITY];
	if(self)
	{
	}
	return self;
}

- (id) initWithStartingBalance:(double)theStartBalance
		andStartDate:(NSDate *)theStartDate
{
	self = [super initWithStartingBalance:theStartBalance 
		andStartDate:theStartDate andWithdrawPriority:CASH_WITHDRAW_PRIORITY];
	return self;
}


- (BalanceAdjustment*)advanceCurrentBalanceToDate:(NSDate*)newDate
{
	assert(newDate != nil);
	assert([DateHelper dateIsEqualOrLater:newDate otherDate:self.currentBalanceDate]);
	self.currentBalanceDate = newDate;
	// NOTE - current balance is left unchanged
	return [[[BalanceAdjustment alloc] initWithZeroAmount] autorelease];
}

- (bool)doTaxWithdrawals
{
	return FALSE;
}

- (bool)doTaxInterest
{
	return FALSE;
}


- (NSString*)balanceName
{
	return LOCALIZED_STR(@"CASH_LABEL");
}


@end
