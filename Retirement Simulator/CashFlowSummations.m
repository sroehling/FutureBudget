//
//  CashFlowSummations.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CashFlowSummations.h"
#import "DateHelper.h"
#import "CashFlowSummation.h"

@implementation CashFlowSummations

@synthesize startDate;
@synthesize yearlySummation;


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
		
		self.yearlySummation = [[[CashFlowSummation alloc] init] autorelease];
		
		assert(theStartDate != nil);
		self.startDate = theStartDate;
	}
	return self;
}

- (id) init
{
	assert(0); // must call init method with start date
}



- (void)resetSummations
{
	for(int i=0; i < MAX_DAYS_IN_YEAR; i++)
	{
		CashFlowSummation *theSummation = (CashFlowSummation*)[cashFlowSummations objectAtIndex:i];
		assert(theSummation != nil);
		[theSummation resetSummations];
	}
	[yearlySummation resetSummations];
}

- (void)resetSummationsAndAdvanceStartDate:(NSDate*)newStartDate
{
	assert(newStartDate!= nil);
	self.startDate= newStartDate;
	[self resetSummations];
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

- (CashFlowSummation*)summationForDayIndex:(NSInteger)dayIndex
{
	assert(dayIndex >= 0);
	assert(dayIndex < MAX_DAYS_IN_YEAR);
	CashFlowSummation *cashFlowSummation = 
			(CashFlowSummation*)[cashFlowSummations objectAtIndex:dayIndex];
	assert(cashFlowSummation != nil);
	return cashFlowSummation;
}

- (void)addExpense:(BalanceAdjustment*)amount onDate:(NSDate*)expenseDate
{
	CashFlowSummation *theSummation = [self summationForDate:expenseDate];
	[theSummation addExpense:amount];
	[yearlySummation addExpense:amount];
}

- (void)addIncome:(double)amount onDate:(NSDate*)incomeDate
{
	CashFlowSummation *theSummation = [self summationForDate:incomeDate];
	[theSummation addIncome:amount];
	[yearlySummation addIncome:amount];

}

- (void)addSavingsContrib:(SavingsContribDigestEntry*)savingsContrib onDate:(NSDate*)contribDate
{
	CashFlowSummation *theSummation = [self summationForDate:contribDate];
	[theSummation addSavingsContrib:savingsContrib];
	[yearlySummation addSavingsContrib:savingsContrib];
}

- (void) dealloc
{
	[super dealloc];
	[cashFlowSummations release];
	[startDate release];
	[yearlySummation release];
}



@end
