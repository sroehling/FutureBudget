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


@implementation SavingsWorkingBalance

@synthesize savingsAcct;

- (id) initWithSavingsAcct:(SavingsAccount*)theSavingsAcct
{
	double theStartBalance = [theSavingsAcct.startingBalance doubleValue];
	self = [super initWithStartingBalance:theStartBalance];
	if(self)
	{
		assert(theSavingsAcct != nil);
		self.savingsAcct = theSavingsAcct;
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
	[super carryBalanceForward:newStartDate];
	startingBalance = self.currentBalance;
}

- (void) dealloc
{
	[super dealloc];
	[savingsAcct release];
}


@end
