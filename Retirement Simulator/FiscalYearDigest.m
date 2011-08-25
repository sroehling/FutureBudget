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
#import "CashFlowSummations.h"

@implementation FiscalYearDigest

@synthesize startDate;
@synthesize workingBalanceMgr;
@synthesize cashFlowSummations;


-(id)initWithStartDate:(NSDate*)theStartDate andWorkingBalances:(WorkingBalanceMgr*)wbMgr
{
	self = [super init];
	if(self)
	{
		
		assert(theStartDate != nil);
		self.startDate = theStartDate;

		self.cashFlowSummations = [[[CashFlowSummations alloc] initWithStartDate:theStartDate] autorelease];
		
		assert(wbMgr != nil);
		self.workingBalanceMgr = wbMgr;
	}
	return self;
}


- (void)processDigestEntries
{
	
	EndOfYearDigestResult *endOfYearResults = [[[EndOfYearDigestResult alloc] init] autorelease];
	double effectiveIncomeTaxRate = 0.25;
	
	NSDate *currentDate = self.startDate;
	for(int currDayIndex=0; currDayIndex < MAX_DAYS_IN_YEAR; currDayIndex++)
	{
		
		CashFlowSummation *currDayCashFlowSummation = 
			[self.cashFlowSummations summationForDayIndex:currDayIndex];
		
		if(currDayCashFlowSummation.sumIncome >0.0)
		{
			[endOfYearResults incrementTotalIncome:currDayCashFlowSummation.sumIncome];
			
			assert(effectiveIncomeTaxRate >= 0.0);
			assert(effectiveIncomeTaxRate <= 1.0);
			double taxesToPayOnIncome = currDayCashFlowSummation.sumIncome * effectiveIncomeTaxRate;
			double afterTaxIncome = currDayCashFlowSummation.sumIncome - taxesToPayOnIncome;
						
			[self.workingBalanceMgr 
				incrementCashBalance:afterTaxIncome asOfDate:currentDate];
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


	[self.cashFlowSummations resetSummationsAndAdvanceStartDate:self.startDate];
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
