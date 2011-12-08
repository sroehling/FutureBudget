//
//  WorkingBalanceList.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkingBalanceCltn.h"
#import "WorkingBalance.h"
#import "CollectionHelper.h"
#import "Input.h"

@implementation WorkingBalanceCltn

@synthesize workingBalList;
@synthesize inputWorkingBalMap;

- (id)init
{
	self = [super init];
	if(self)
	{
		self.workingBalList = [[[NSMutableArray alloc] init] autorelease];
		needsSorting = true;
		
		self.inputWorkingBalMap = [[[NSMutableDictionary alloc] init] autorelease];
	}
	return self;
}

- (void)addBalance:(WorkingBalance*)workingBal
{
	assert(workingBal != nil);
	[self.workingBalList addObject:workingBal];
	needsSorting = true;

}

- (WorkingBalance*)findWorkingBalanceForInput:(Input*)theInput
{
	assert(theInput != nil);
	return [self.inputWorkingBalMap objectForKey:[theInput objectID]];
}

- (WorkingBalance*)getWorkingBalanceForInput:(Input*)theInput
{
	WorkingBalance *workingBal = [self findWorkingBalanceForInput:theInput];
	assert(workingBal != nil);
	return workingBal;
}


- (void)addBalance:(WorkingBalance*)workingBal forInput:(Input*)theInput
{
	assert(theInput != nil);
	assert(workingBal != nil);
	
	[self addBalance:workingBal];
	
	assert([self findWorkingBalanceForInput:theInput] == nil); // duplicates not allowed
	
	[self.inputWorkingBalMap setObject:workingBal forKey:[theInput objectID]];

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
		[CollectionHelper sortMutableArrayInPlace:self.workingBalList 
			withKey:WORKING_BALANCE_WITHDRAWAL_PRIORITY_KEY ascending:TRUE];
	}
	needsSorting = false;
}


- (void)advanceBalancesToDate:(NSDate*)newDate
{
	for(WorkingBalance *workingBal in self.workingBalList)
	{
		assert(workingBal!=nil);
		[workingBal advanceCurrentBalanceToDate:newDate];
	}
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
	[inputWorkingBalMap release];
}

@end
