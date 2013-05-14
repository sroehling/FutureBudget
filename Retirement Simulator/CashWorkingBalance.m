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
#import "LocalizationHelper.h"

// Cash always has the highest priority for withdrawals.
#define CASH_WITHDRAW_PRIORITY -1.0

// TODO - Need to verify that all other priorities are >= 0.0

@implementation CashWorkingBalance



- (id) initWithStartingBalance:(double)theStartBalance
		andStartDate:(NSDate *)theStartDate
{
	self = [super initWithStartingBalance:theStartBalance 
		andStartDate:theStartDate andWithdrawPriority:CASH_WITHDRAW_PRIORITY];
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}


- (void)advanceCurrentBalanceToDate:(NSDate*)newDate
{
	assert(newDate != nil);
	
	// Advancing to the current date is a no-op if the newDate is before the current date.
	// If the current date is in the future, then this working balance is typically for 
	// an input such as a loan or asset which is originated or purchased in the future. 
	if([DateHelper dateIsLater:newDate otherDate:self.currentBalanceDate])
	{
		self.currentBalanceDate = newDate;
		// NOTE - current balance is left unchanged
	}

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
