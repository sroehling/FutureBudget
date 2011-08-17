//
//  ExpenseSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExpenseSimEventCreator.h"
#import "ExpenseSimEvent.h"
#import "ExpenseInput.h"

#import "SimEvent.h"

@implementation ExpenseSimEventCreator

@synthesize expense;

- (SimEvent*) createCashFlowSimEvent:(double)cashFlowAmount andEventDate:(NSDate*)theDate
{
	ExpenseSimEvent *expenseEvent = [[[ExpenseSimEvent alloc]initWithEventCreator:self 
			andEventDate:theDate ] autorelease];
	expenseEvent.expense = self.expense;
	expenseEvent.expenseAmount = cashFlowAmount;

	return expenseEvent;
}

- (id)initWithExpense:(ExpenseInput*)theExpense
{
	self = [super initWithCashFlow:theExpense];
	if(self)
	{
		self.expense = theExpense;
	}
	return self;
}

- (id) initWithCashFlow:(CashFlowInput *)theCashFlow
{
	assert(0); // must init with expense
}

- (void)dealloc
{
	[super dealloc];
	[expense release];
}

@end
