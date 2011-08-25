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
#import "EndOfYearDigestResult.h"
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

- (void)processDigestEntries
{
	
	EndOfYearDigestResult *endOfYearResults = [[[EndOfYearDigestResult alloc] init] autorelease];
	
	NSDate *currentDate = self.startDate;
	for(int i=0; i < MAX_DAYS_IN_YEAR; i++)
	{
		
		CashFlowSummation *currDayCashFlowSummation = 
			(CashFlowSummation*)[cashFlowSummations objectAtIndex:i];
		assert(currDayCashFlowSummation != nil);
		if(currDayCashFlowSummation.sumIncome >0.0)
		{
			[endOfYearResults incrementTotalIncome:currDayCashFlowSummation.sumIncome];
			
#warning TODO - Subtract taxes to be paid before incrementing the cash balance			
			
			[self.workingBalanceMgr 
				incrementCashBalance:currDayCashFlowSummation.sumIncome asOfDate:currentDate];
		}
		if([currDayCashFlowSummation.sumExpenses totalAmount] > 0.0)
		{
			[endOfYearResults incrementTotalExpense:currDayCashFlowSummation.sumExpenses];
			BalanceAdjustment *amountDecremented = 
				[self.workingBalanceMgr 
				decrementBalanceFromFundingList:[currDayCashFlowSummation.sumExpenses totalAmount] 
				asOfDate:currentDate];
			assert([amountDecremented totalAmount] <= [currDayCashFlowSummation.sumExpenses totalAmount]);
		}
		if([currDayCashFlowSummation.savingsContribs count] > 0)
		{
			for(SavingsContribDigestEntry *savingsContrib in currDayCashFlowSummation.savingsContribs)
			{
				if(savingsContrib.contribAmount>0.0)
				{
					double actualContrib = [self.workingBalanceMgr
						decrementAvailableCashBalance:savingsContrib.contribAmount 
						asOfDate:currentDate];
					if(actualContrib>0.0)
					{
						BalanceAdjustment *contribAdjustment = 
							[[[BalanceAdjustment alloc] initWithAmount:actualContrib 
							andIsAmountTaxable:savingsContrib.contribIsTaxable] autorelease];
						[endOfYearResults incrementTotalExpense:contribAdjustment];
						[savingsContrib.workingBalance incrementBalance:actualContrib asOfDate:currentDate];
					}
				}
			}
		}
		currentDate = [DateHelper nextDay:currentDate];
	} // for each day in the year

	[endOfYearResults logResults];
	[self.workingBalanceMgr logCurrentBalances];
}

- (void)advanceToNextYear
{
	
	NSLog(@"Advancing digest to next year from last year start = %@",
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:self.startDate]);
	[self.workingBalanceMgr logCurrentBalances];

	[self processDigestEntries];

	// Advance the digest to the next year
	

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
