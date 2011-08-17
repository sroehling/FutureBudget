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
#import "SharedAppValues.h"
#import "Cash.h"

@implementation FiscalYearDigest

@synthesize startDate;
@synthesize cashWorkingBalance;

-(id)initWithStartDate:(NSDate*)theStartDate
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
		
		Cash *theCash = [SharedAppValues singleton].cash;
		assert(theCash != nil);
		double startingCashBalance = [theCash.startingBalance doubleValue];
		self.cashWorkingBalance = [[[CashWorkingBalance alloc]
			initWithStartDate:[SharedAppValues singleton].simStartDate 
			andStartingBalance:startingCashBalance] autorelease];
		
		
		
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
	double totalExpense = 0.0;
	for(int i=0; i < MAX_DAYS_IN_YEAR; i++)
	{
		CashFlowSummation *theSummation = (CashFlowSummation*)[cashFlowSummations objectAtIndex:i];
		assert(theSummation != nil);
		totalIncome += theSummation.sumIncome;
		[self.cashWorkingBalance incrementBalance:theSummation.sumIncome];
		totalExpense += theSummation.sumExpenses;
		[self.cashWorkingBalance decrementBalance:theSummation.sumExpenses];
	}

	NSString *totalIncomeCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:totalIncome]];
	NSLog(@"Total Income: %@",totalIncomeCurrency);
	NSString *totalExpenseCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:totalExpense]];
	NSLog(@"Total Expense: %@",totalExpenseCurrency);
	
	NSString *currentCashCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.cashWorkingBalance.currentBalance]];
	NSLog(@"Total Cash balance: %@",currentCashCurrency);
	

	self.startDate = [DateHelper beginningOfNextYear:self.startDate];

	[self.cashWorkingBalance carryBalanceForward:self.startDate];

	[self resetSummations];
}

- (void)addExpense:(double)amount onDate:(NSDate*)expenseDate
{
	CashFlowSummation *theSummation = [self summationForDate:expenseDate];
	[theSummation addExpense:amount];
}

- (void)addIncome:(double)amount onDate:(NSDate*)incomeDate
{
	CashFlowSummation *theSummation = [self summationForDate:incomeDate];
	[theSummation addIncome:amount];

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
	[cashWorkingBalance release];
}

@end
