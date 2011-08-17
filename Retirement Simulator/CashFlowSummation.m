//
//  CashFlowSummation.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CashFlowSummation.h"


@implementation CashFlowSummation

@synthesize sumExpenses;
@synthesize sumIncome;

-(id)init
{
	self = [super init];
	if(self)
	{
		[self resetSummations];
	}
	return self;
}

- (void)addIncome:(double)incomeAmount;
{
	assert(incomeAmount >=0.0);
	sumIncome += incomeAmount;
}

- (void)addExpense:(double)expenseAmount
{
	assert(expenseAmount >= 0.0);
	sumExpenses += expenseAmount;
}

- (void)resetSummations
{
	sumIncome = 0.0;
	sumExpenses = 0.0;
}

@end
