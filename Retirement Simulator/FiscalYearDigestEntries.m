//
//  CashFlowSummations.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FiscalYearDigestEntries.h"
#import "DateHelper.h"
#import "DigestEntryCltn.h"

@implementation FiscalYearDigestEntries

@synthesize startDate;
@synthesize dailyDigestEntries;

-(id)initWithStartDate:(NSDate*)theStartDate
{
	self = [super init];
	if(self)
	{
		DigestEntryCltn *entriesInit[MAX_DAYS_IN_YEAR];
		for(int i = 0; i < MAX_DAYS_IN_YEAR; i++)
		{
			entriesInit[i] = [[[DigestEntryCltn alloc] init] autorelease];
		}
		self.dailyDigestEntries = [[[NSArray alloc] 
			initWithObjects:entriesInit count:MAX_DAYS_IN_YEAR] autorelease];
				
		assert(theStartDate != nil);
		self.startDate = theStartDate;
	}
	return self;
}

- (id) init
{
	assert(0); // must call init method with start date
}


- (void)resetEntries
{
	for(int i=0; i < MAX_DAYS_IN_YEAR; i++)
	{
		DigestEntryCltn *theEntries = (DigestEntryCltn*)[self.dailyDigestEntries objectAtIndex:i];
		assert(theEntries != nil);
		[theEntries resetEntries];
	}
}

- (void)resetEntriesAndAdvanceStartDate:(NSDate*)newStartDate
{
	assert(newStartDate!= nil);
	self.startDate= newStartDate;
	[self resetEntries];
}

- (DigestEntryCltn*)entriesForDate:(NSDate*)eventDate
{
	assert(eventDate!=nil);
	assert(startDate!=nil);
	assert(eventDate == [eventDate laterDate:startDate]);
	NSTimeInterval timeAfterStart = [eventDate timeIntervalSinceDate:startDate];
	assert(timeAfterStart>=0.0);
	NSInteger daysSinceStart = floor(timeAfterStart / SECONDS_PER_DAY);
	assert(daysSinceStart < MAX_DAYS_IN_YEAR);
	DigestEntryCltn *theEntries = (DigestEntryCltn*)[self.dailyDigestEntries objectAtIndex:daysSinceStart];
	assert(theEntries != nil);
	return theEntries;
}

- (DigestEntryCltn*)entriesForDayIndex:(NSInteger)dayIndex
{
	assert(dayIndex >= 0);
	assert(dayIndex < MAX_DAYS_IN_YEAR);
	DigestEntryCltn *theEntries = 
			(DigestEntryCltn*)[self.dailyDigestEntries objectAtIndex:dayIndex];
	assert(theEntries != nil);
	return theEntries;
}


-(void)addDigestEntry:(id<DigestEntry>)digestEntry onDate:(NSDate*)entryDate
{
	DigestEntryCltn *theEntries = [self entriesForDate:entryDate];
	[theEntries addDigestEntry:digestEntry];
}


- (void)markEndDateForEstimatedTaxAccrual:(NSDate*)taxEndDate
{
	DigestEntryCltn *theEntries = [self entriesForDate:taxEndDate];
	[theEntries markAsEndDateForEstimatedTaxAccrual];
}

- (void)markDateForEstimatedTaxPayment:(NSDate*)taxPaymentDate
{
	DigestEntryCltn *theEntries = [self entriesForDate:taxPaymentDate];
	[theEntries markAsEstimatedTaxPaymentDay];

}

- (void) dealloc
{
	[dailyDigestEntries release];
	[startDate release];
	[super dealloc];
}



@end
