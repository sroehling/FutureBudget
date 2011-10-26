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
@synthesize cashFlowSummations;

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
		self.cashFlowSummations = [[[NSArray alloc] 
			initWithObjects:summationInit count:MAX_DAYS_IN_YEAR] autorelease];
				
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
		CashFlowSummation *theSummation = (CashFlowSummation*)[self.cashFlowSummations objectAtIndex:i];
		assert(theSummation != nil);
		[theSummation resetSummations];
	}
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
	CashFlowSummation *theSummation = (CashFlowSummation*)[self.cashFlowSummations objectAtIndex:daysSinceStart];
	assert(theSummation != nil);
	return theSummation;
}

- (CashFlowSummation*)summationForDayIndex:(NSInteger)dayIndex
{
	assert(dayIndex >= 0);
	assert(dayIndex < MAX_DAYS_IN_YEAR);
	CashFlowSummation *cashFlowSummation = 
			(CashFlowSummation*)[self.cashFlowSummations objectAtIndex:dayIndex];
	assert(cashFlowSummation != nil);
	return cashFlowSummation;
}


-(void)addDigestEntry:(id<DigestEntry>)digestEntry onDate:(NSDate*)entryDate
{
	CashFlowSummation *theSummation = [self summationForDate:entryDate];
	[theSummation addDigestEntry:digestEntry];
}


- (void)markEndDateForEstimatedTaxAccrual:(NSDate*)taxEndDate
{
	CashFlowSummation *theSummation = [self summationForDate:taxEndDate];
	[theSummation markAsEndDateForEstimatedTaxAccrual];
}

- (void)markDateForEstimatedTaxPayment:(NSDate*)taxPaymentDate
{
	CashFlowSummation *theSummation = [self summationForDate:taxPaymentDate];
	[theSummation markAsEstimatedTaxPaymentDay];

}

- (void) dealloc
{
	[super dealloc];
	[cashFlowSummations release];
	[startDate release];
}



@end
