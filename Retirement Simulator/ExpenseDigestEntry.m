//
//  ExpenseDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExpenseDigestEntry.h"
#import "InputValDigestSummation.h"
#import "WorkingBalanceMgr.h"
#import "DigestEntryProcessingParams.h"
#import "ExpenseSimInfo.h"
#import "ExpenseInput.h"

@implementation ExpenseDigestEntry

@synthesize expenseInfo;

- (id)initWithExpenseInfo:(ExpenseSimInfo*)theExpenseInfo andAmount:(double)theAmount
{
	self = [super initWithAmount:theAmount 
		andCashFlowSummation:theExpenseInfo.digestSum];
	if(self)
	{
		self.expenseInfo = theExpenseInfo;
	}
	return self;
}

-(void)processDigestEntry:(DigestEntryProcessingParams*)processingParams
{
	[self.cashFlowSummation adjustSum:self.amount onDay:processingParams.dayIndex];
		
	[processingParams.workingBalanceMgr decrementBalanceFromFundingList:self.amount 
		asOfDate:processingParams.currentDate forExpense:self.expenseInfo.expense];
}

-(void)dealloc
{
	[expenseInfo release];
	[super dealloc];
}


@end
