//
//  LoanDownPmtSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoanDownPmtSimEvent.h"

#import "ExpenseDigestEntry.h"
#import "InputValDigestSummation.h"
#import "FiscalYearDigest.h"
#import "FiscalYearDigestEntries.h"


@implementation LoanDownPmtSimEvent

@synthesize downPmtAmt;


-(id)initWithEventCreator:(id<SimEventCreator>)eventCreator 
	andEventDate:(NSDate *)theEventDate andAmount:(double)theAmount
{
	self = [super initWithEventCreator:eventCreator andEventDate:theEventDate];
	if(self)
	{
		assert(theAmount >= 0.0);
		self.downPmtAmt = theAmount;
	}
	return self;
}

- (void)doSimEvent:(FiscalYearDigest*)digest
{
	// TODO - Need to store this somewhere else, for complete tracking of expenses.
	InputValDigestSummation *digestSum = [[[InputValDigestSummation alloc] init] autorelease];	  
		
	ExpenseDigestEntry *expenseEntry =
		[[[ExpenseDigestEntry alloc] initWithAmount:self.downPmtAmt 
			andCashFlowSummation:digestSum] autorelease];
		  
	[digest.digestEntries addDigestEntry:expenseEntry onDate:self.eventDate];
}


@end
