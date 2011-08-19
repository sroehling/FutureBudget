//
//  WorkingBalanceList.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkingBalanceMgr.h"
#import "SharedAppValues.h"
#import "WorkingBalance.h"
#import "CashWorkingBalance.h"
#import "NumberHelper.h"
#import "DateHelper.h"
#import "Cash.h"

@implementation WorkingBalanceMgr

@synthesize workingBalances;
@synthesize cashWorkingBalance;

- (id)initWithStartDate:(NSDate*)startDate
{
	self = [super init];
	if(self)
	{
		self.workingBalances = [[[NSMutableArray alloc] init] autorelease];
		
		self.cashWorkingBalance = [[[CashWorkingBalance alloc] init] autorelease];
		[self addWorkingBalance:cashWorkingBalance];

	}
	return self;
}

- (id) init
{
	assert(0); // need to call with start date
}

- (void)addWorkingBalance:(WorkingBalance*)theBalance
{
	assert(theBalance!= nil);
	[self.workingBalances addObject:theBalance];
}

- (void)carryBalancesForward:(NSDate*)newDate
{
	assert(newDate != nil);
	for(WorkingBalance *workingBal in self.workingBalances)
	{
		assert(workingBal!=nil);
		[workingBal carryBalanceForward:newDate];
	}
	
	NSString *currentCashCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.cashWorkingBalance.currentBalance]];
	NSLog(@"Total Cash balance: %@",currentCashCurrency);

}

- (void) incrementBalance:(double)incomeAmount  asOfDate:(NSDate*)newDate
{
	[self.cashWorkingBalance incrementBalance:incomeAmount asOfDate:newDate];
}

- (void) decrementBalance:(double)expenseAmount  asOfDate:(NSDate*)newDate
{
	[self.cashWorkingBalance decrementBalance:expenseAmount asOfDate:newDate];
}

- (double) decrementAvailableCashBalance:(double)expenseAmount asOfDate:(NSDate*)newDate
{
	return [self.cashWorkingBalance 
		decrementAvailableBalance:expenseAmount asOfDate:newDate];
}

- (void) resetCurrentBalances
{
	for(WorkingBalance *workingBal in self.workingBalances)
	{
		assert(workingBal!=nil);
		[workingBal resetCurrentBalance];
	}

}

- (void) dealloc
{
	[super dealloc];
	[workingBalances release];
	[cashWorkingBalance release];
}

@end
