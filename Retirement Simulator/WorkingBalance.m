//
//  WorkingBalance.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkingBalance.h"
#import "SharedAppValues.h"
#import "DateHelper.h"


@implementation WorkingBalance

@synthesize balanceStartDate;
@synthesize currentBalance;
@synthesize startingBalance;
@synthesize currentBalanceDate;

- (id) initWithStartingBalance:(double)theStartBalance
{
	self = [super init];
	if(self)
	{
		self.balanceStartDate = [DateHelper beginningOfDay:[SharedAppValues singleton].simStartDate];
		startingBalance = theStartBalance;
		[self resetCurrentBalance];
	}
	return self;
}

- (id) init
{
	assert(0); // must call initWithStartDate
}

- (void) resetCurrentBalance
{
	currentBalance = startingBalance;
	self.currentBalanceDate = self.balanceStartDate;
}

- (void) dealloc
{
	[super dealloc];
	[balanceStartDate release];
}

- (void)advanceCurrentBalanceToDate:(NSDate*)newDate
{
	assert(newDate != nil);
	assert([DateHelper dateIsEqualOrLater:newDate otherDate:self.currentBalanceDate]);
	self.currentBalanceDate = newDate;
}

- (void) incrementBalance:(double)amount asOfDate:(NSDate*)newDate
{
	[self advanceCurrentBalanceToDate:newDate];

	assert(amount >= 0.0);
	currentBalance += amount;
}

- (void) decrementBalance:(double)amount asOfDate:(NSDate*)newDate
{
	[self advanceCurrentBalanceToDate:newDate];
	
	assert(amount >= 0.0);	
	currentBalance -= amount;
}

- (double) decrementAvailableBalance:(double)amount asOfDate:(NSDate*)newDate
{
	[self advanceCurrentBalanceToDate:newDate];
	
	assert(amount >= 0.0);	

	if(currentBalance > 0.0)
	{
		if(amount >= currentBalance)
		{
			currentBalance -= amount;
			return amount;
		}
		else
		{
			double availableAmount = currentBalance;
			currentBalance = 0.0;
			return availableAmount;
		}
	}
	else
	{
		return 0.0;
	}

}


- (void)carryBalanceForward:(NSDate*)newStartDate
{
	assert(newStartDate != nil);
	assert(newStartDate == [self.currentBalanceDate laterDate:newStartDate]);
	self.balanceStartDate = newStartDate;
	self.currentBalanceDate = newStartDate;
}



@end
