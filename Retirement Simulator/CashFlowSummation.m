//
//  CashFlowSummation.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CashFlowSummation.h"
#import "BalanceAdjustment.h"
#import "SavingsContribDigestEntry.h"


@implementation CashFlowSummation

@synthesize sumExpenses;
@synthesize sumIncome;
@synthesize savingsContribs;
@synthesize sumContributions;

-(id)init
{
	self = [super init];
	if(self)
	{
		self.savingsContribs = [[[NSMutableArray alloc] init] autorelease];
		self.sumExpenses = [[[BalanceAdjustment alloc] initWithZeroAmount] autorelease];
		[self resetSummations];
		
		self.sumContributions = [[[BalanceAdjustment alloc] initWithZeroAmount] autorelease];
	}
	return self;
}

- (void)addIncome:(double)incomeAmount;
{
	assert(incomeAmount >=0.0);
	sumIncome += incomeAmount;
}

- (void)addExpense:(BalanceAdjustment*)expenseAmount
{
	assert(expenseAmount != nil);
	assert([expenseAmount totalAmount] >= 0.0);
	[sumExpenses addAdjustment:expenseAmount];
}

- (void) addSavingsContrib:(SavingsContribDigestEntry*)savingsContrib
{
	assert(savingsContrib != nil);
	[self.savingsContribs addObject:savingsContrib];
	[self.sumContributions addAdjustment:savingsContrib.contribAdjustment];
}

- (void)resetSummations
{
	sumIncome = 0.0;
	
	[sumExpenses resetToZero];
	
	[self.savingsContribs removeAllObjects];
	[self.sumContributions resetToZero];
}

-(double)totalDeductions
{
	double totalDeductableExpense = self.sumExpenses.taxFreeAmount;
	double totalDeductableContributions = self.sumContributions.taxFreeAmount;
	double totalDeductions = totalDeductableExpense + totalDeductableContributions;
	return totalDeductions;
}


- (void) dealloc
{
	[super dealloc];
	[savingsContribs release];
	[sumContributions release];
	[sumExpenses release];
}

@end
