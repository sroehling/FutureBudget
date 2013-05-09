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

NSString * const WORKING_BALANCE_WITHDRAWAL_PRIORITY_KEY = @"withdrawPriority";

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

- (void)addBalance:(id<WorkingBalance>)workingBal
{
	assert(workingBal != nil);
	[self.workingBalList addObject:workingBal];
	needsSorting = true;

}

- (id<WorkingBalance>)findWorkingBalanceForInput:(Input*)theInput
{
	assert(theInput != nil);
	return [self.inputWorkingBalMap objectForKey:[theInput objectID]];
}

- (id<WorkingBalance>)getWorkingBalanceForInput:(Input*)theInput
{
	id<WorkingBalance> workingBal = [self findWorkingBalanceForInput:theInput];
	assert(workingBal != nil);
	return workingBal;
}


- (void)addBalance:(id<WorkingBalance>)workingBal forInput:(Input*)theInput
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

	for(id<WorkingBalance> workingBal in self.workingBalList)
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
	for(id<WorkingBalance> workingBal in self.workingBalList)
	{
		assert(workingBal!=nil);
		[workingBal advanceCurrentBalanceToDate:newDate];
	}
}

- (void) resetCurrentBalances
{
	for(id<WorkingBalance> workingBal in self.workingBalList)
	{
		assert(workingBal!=nil);
		[workingBal resetCurrentBalance];
	}
}

-(double)totalBalances:(NSDate*)currentDate
{
	double totalBal = 0.0;
	for(id<WorkingBalance> workingBal in self.workingBalList)
	{
		assert([workingBal currentBalanceForDate:currentDate]>=0.0);
		totalBal += [workingBal currentBalanceForDate:currentDate];
	}
	return totalBal;
}

- (void)dealloc
{
	[workingBalList release];
	[inputWorkingBalMap release];
	[super dealloc];
}

@end
