//
//  CashWorkingBalance.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CashWorkingBalance.h"


@implementation CashWorkingBalance

@synthesize balanceStartDate;
@synthesize currentBalance;
@synthesize startingBalance;

- (id) initWithStartDate:(NSDate*)theStartDate andStartingBalance:(double)theStartBalance
{
	self = [super init];
	if(self)
	{
		self.balanceStartDate = theStartDate;
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
}

- (void) dealloc
{
	[super dealloc];
	[balanceStartDate release];
}



- (void) incrementBalance:(double)amount
{
	assert(amount >= 0.0);
	currentBalance += amount;
}

- (void) decrementBalance:(double)amount;
{
	assert(amount >= 0.0);
	currentBalance -= amount;
}


- (void)carryBalanceForward:(NSDate*)newStartDate
{
	assert(newStartDate != nil);
	self.balanceStartDate = newStartDate;
	startingBalance = currentBalance;
	[self resetCurrentBalance];
}


@end
