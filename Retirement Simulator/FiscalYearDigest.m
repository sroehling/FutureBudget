//
//  FiscalYearDigest.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FiscalYearDigest.h"
#import "CashFlowSummation.h"
#import "DateHelper.h"
#import "NumberHelper.h"
#import "CashWorkingBalance.h"
#import "SavingsContribDigestEntry.h"
#import "BalanceAdjustment.h"
#import "WorkingBalanceMgr.h"
#import "SharedAppValues.h"
#import "SavingsWorkingBalance.h"
#import "Cash.h"

@implementation FiscalYearDigest

@synthesize startDate;
@synthesize workingBalanceMgr;


-(id)initWithStartDate:(NSDate*)theStartDate andWorkingBalances:(WorkingBalanceMgr*)wbMgr
{
	self = [super init];
	if(self)
	{
		CashFlowSummation *summationInit[MAX_DAYS_IN_YEAR];
		for(int i = 0; i < MAX_DAYS_IN_YEAR; i++)
		{
			summationInit[i] = [[[CashFlowSummation alloc] init] autorelease];
		}
		cashFlowSummations = [[NSArray alloc] initWithObjects:summationInit count:MAX_DAYS_IN_YEAR];
		assert(theStartDate != nil);
		self.startDate = theStartDate;
		[startDate retain];
		
		assert(wbMgr != nil);
		self.workingBalanceMgr = wbMgr;
	}
	return self;
}

- (void)resetSummations
{
	for(int i=0; i < MAX_DAYS_IN_YEAR; i++)
	{
		CashFlowSummation *theSummation = (CashFlowSummation*)[cashFlowSummations objectAtIndex:i];
		assert(theSummation != nil);
		[theSummation resetSummations];

	}
}

- (CashFlowSummation*)summationForDate:(NSDate*)eventDate
{
	assert(eventDate!=nil);
	assert(startDate!=nil);
	assert(eventDate == [eventDate laterDate:startDate]);
	NSTimeInterval timeAfterStart = [eventDate timeIntervalSinceDate:startDate];
	assert(timeAfterStart>=0.0);
	NSInteger daysSinceStart = floor(timeAfterStart / SECONDS_PER_DAY);
	assert(daysSinceStart < MAX_DAYS_IN_YEAR);
	CashFlowSummation *theSummation = (CashFlowSummation*)[cashFlowSummations objectAtIndex:daysSinceStart];
	assert(theSummation != nil);
	return theSummation;
}

- (void)advanceToNextYear
{
	double totalIncome = 0.0;
	BalanceAdjustment *totalExpense = [[[BalanceAdjustment alloc] initWithZeroAmount] autorelease];
	
	NSLog(@"Advancing digest to next year from last year start = %@",
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:self.startDate]);
	[self.workingBalanceMgr logCurrentBalances];
	
	NSDate *currentDate = self.startDate;
	for(int i=0; i < MAX_DAYS_IN_YEAR; i++)
	{
		
		CashFlowSummation *theSummation = (CashFlowSummation*)[cashFlowSummations objectAtIndex:i];
		assert(theSummation != nil);
		if(theSummation.sumIncome >0.0)
		{
			totalIncome += theSummation.sumIncome;
			[self.workingBalanceMgr incrementCashBalance:theSummation.sumIncome asOfDate:currentDate];
		}
		if([theSummation.sumExpenses totalAmount] > 0.0)
		{
			[totalExpense addAdjustment:theSummation.sumExpenses];
			BalanceAdjustment *amountDecremented = 
				[self.workingBalanceMgr decrementBalanceFromFundingList:[theSummation.sumExpenses totalAmount] 
				asOfDate:currentDate];
			assert([amountDecremented totalAmount] <= [theSummation.sumExpenses totalAmount]);
		}
		if([theSummation.savingsContribs count] > 0)
		{
			for(SavingsContribDigestEntry *savingsContrib in theSummation.savingsContribs)
			{
				double actualContrib = [self.workingBalanceMgr
					decrementAvailableCashBalance:savingsContrib.contribAmount asOfDate:currentDate];
#warning TODO - Need to distinguish between tax free contributions and taxable contributions
				BalanceAdjustment *contribAdjustment = 
					[[[BalanceAdjustment alloc] initWithTaxFreeAmount:0.0 andTaxableAmount:actualContrib] autorelease];
				[totalExpense addAdjustment:contribAdjustment];
				[savingsContrib.workingBalance incrementBalance:actualContrib asOfDate:currentDate];
			}
		}
		currentDate = [DateHelper nextDay:currentDate];
	}

	NSString *totalIncomeCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:totalIncome]];
	NSLog(@"Total Income: %@",totalIncomeCurrency);
	NSString *totalExpenseCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:[totalExpense totalAmount]]];
	NSLog(@"Total Expense: %@",totalExpenseCurrency);
	[self.workingBalanceMgr logCurrentBalances];
	
	

	self.startDate = [DateHelper beginningOfNextYear:self.startDate];
	[self.workingBalanceMgr carryBalancesForward:self.startDate];
	NSLog(@"Done Advancing digest to next year start = %@",
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:self.startDate]);


	[self resetSummations];
}

- (void)addExpense:(BalanceAdjustment*)amount onDate:(NSDate*)expenseDate
{
	CashFlowSummation *theSummation = [self summationForDate:expenseDate];
	[theSummation addExpense:amount];
}

- (void)addIncome:(double)amount onDate:(NSDate*)incomeDate
{
	CashFlowSummation *theSummation = [self summationForDate:incomeDate];
	[theSummation addIncome:amount];

}

- (void)addSavingsContrib:(SavingsContribDigestEntry*)savingsContrib onDate:(NSDate*)contribDate
{
	CashFlowSummation *theSummation = [self summationForDate:contribDate];
	[theSummation addSavingsContrib:savingsContrib];
}

- (id) init
{
	assert(0); // must call init method above
}

- (void) dealloc
{
	[super dealloc];
	[cashFlowSummations release];
	[startDate release];

}

@end
