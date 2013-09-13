//
//  LoanEarlyPayoffSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LoanEarlyPayoffSimEvent.h"
#import "FiscalYearDigest.h"
#import "FiscalYearDigestEntries.h"
#import "DateHelper.h"
#import "LoanEarlyPayoffDigestEntry.h"
#import "LoanSimInfo.h"
#import "LoanInput.h"

@implementation LoanEarlyPayoffSimEvent

@synthesize loanInfo;

- (id)initWithLoanInfo:(LoanSimInfo*)theLoanInfo 
	andEventCreator:(id<SimEventCreator>)theEventCreator 
	andEventDate:(NSDate *)theEventDate
{
	self = [super initWithEventCreator:theEventCreator andEventDate:theEventDate];
	if(self)
	{
		assert(theLoanInfo != nil);
		self.loanInfo = theLoanInfo;
	}
	return self;
}


-(id) init
{
	assert(0); // must init with balance and payment amount
	return nil;
}

- (void)doSimEvent:(FiscalYearDigest*)digest
{
	LoanEarlyPayoffDigestEntry *loanPayoff = [[[LoanEarlyPayoffDigestEntry alloc] 
		initWithLoanInfo:self.loanInfo] autorelease];
		  
	[digest.digestEntries addDigestEntry:loanPayoff onDate:self.eventDate];
}

-(void)dealloc
{
	[loanInfo release];
	[super dealloc];
}


@end
