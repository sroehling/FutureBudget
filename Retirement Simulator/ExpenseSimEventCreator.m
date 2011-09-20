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
	bool doTaxExpense = [self.expense.taxDeductible boolValue]?FALSE:TRUE;
	
	ExpenseSimEvent *expenseEvent = [[[ExpenseSimEvent alloc]initWithEventCreator:self 
			andEventDate:theDate andAmount:cashFlowAmount andIsTaxable:doTaxExpense] autorelease];

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
