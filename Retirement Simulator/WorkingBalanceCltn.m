//
//  WorkingBalanceList.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkingBalanceCltn.h"
#import "WorkingBalance.h"
#import "BalanceAdjustment.h"
#import "CollectionHelper.h"
#import "WorkingBalanceAdjustment.h"

@implementation WorkingBalanceCltn

@synthesize workingBalList;

- (id)init
{
	self = [super init];
	if(self)
	{
		self.workingBalList = [[[NSMutableArray alloc] init] autorelease];
		needsSorting = true;
	}
	return self;
}

- (void)addBalance:(WorkingBalance*)workingBal
{
	assert(workingBal != nil);
	[self.workingBalList addObject:workingBal];
	needsSorting = true;
}

- (void)carryBalancesForward:(NSDate*)newDate
{
	assert(newDate != nil);

	for(WorkingBalance *workingBal in self.workingBalList)
	{
		assert(workingBal!=nil);
		[workingBal carryBalanceForward:newDate];
	}
}

- (void)sortByWithdrawalOrder
{
	if(needsSorting)
	{
		[CollectionHelper sortMutableArrayInPlace:self.workingBalList withKey:WORKING_BALANCE_WITHDRAWAL_PRIORITY_KEY ascending:TRUE];
	}
	needsSorting = false;
}


- (BalanceAdjustment*)advanceBalancesToDate:(NSDate*)newDate
{
	BalanceAdjustment *totalInterest = [[[BalanceAdjustment alloc] initWithZeroAmount] autorelease];
	for(WorkingBalance *workingBal in self.workingBalList)
	{
		assert(workingBal!=nil);
		BalanceAdjustment *currentWorkingBalInterest = 
			[workingBal advanceCurrentBalanceToDate:newDate];
		[totalInterest addAdjustment:currentWorkingBalInterest];
	}
	return totalInterest;
}

- (void) resetCurrentBalances
{
	for(WorkingBalance *workingBal in self.workingBalList)
	{
		assert(workingBal!=nil);
		[workingBal resetCurrentBalance];
	}
}

- (void)logCurrentBalances
{
	for(WorkingBalance *workingBal in self.workingBalList)
	{
		[workingBal logBalance];
	}
}

-(double)totalBalances
{
	double totalBal = 0.0;
	for(WorkingBalance *workingBal in self.workingBalList)
	{
		assert([workingBal currentBalance]>=0.0);
		totalBal += [workingBal currentBalance];
	}
	return totalBal;
}

- (void)dealloc
{
	[super dealloc];
	[workingBalList release];
}

@end
