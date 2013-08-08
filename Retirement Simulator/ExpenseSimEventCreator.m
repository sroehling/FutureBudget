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
#import "ExpenseSimInfo.h"
#import "SimParams.h"
#import "SimEvent.h"

@implementation ExpenseSimEventCreator

@synthesize expenseInfo;

- (SimEvent*) createCashFlowSimEvent:(double)cashFlowAmount andEventDate:(NSDate*)theDate
{	
	ExpenseSimEvent *expenseEvent = [[[ExpenseSimEvent alloc]initWithEventCreator:self 
			andEventDate:theDate andAmount:cashFlowAmount andExpenseInfo:self.expenseInfo] autorelease];
    expenseEvent.tieBreakPriority = SIM_EVENT_TIE_BREAK_PRIORITY_EXPENSE;

	return expenseEvent;
}

- (id)initWithExpenseInfo:(ExpenseSimInfo*)theExpenseInfo
{
	self = [super initWithCashFlow:theExpenseInfo.expense 
		andSimStartDate:theExpenseInfo.simParams.simStartDate];
	if(self)
	{
		assert(theExpenseInfo != nil);
		self.expenseInfo = theExpenseInfo;
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
	[expenseInfo release];
}

@end
