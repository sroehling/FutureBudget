//
//  LoanPaymentSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoanPaymentSimEvent.h"
#import "NumberHelper.h"
#import "DateHelper.h"
#import "InterestBearingWorkingBalance.h"
#import "LoanPmtDigestEntry.h"
#import "FiscalYearDigestEntries.h"
#import "FiscalYearDigest.h"
#import "LoanSimInfo.h"

@implementation LoanPaymentSimEvent

@synthesize loanInfo;
@synthesize pmtProcessor;


- (void)dealloc
{
	[loanInfo release];
	[pmtProcessor release];
	[super dealloc];
}


- (void)doSimEvent:(FiscalYearDigest*)digest
{
	assert(self.loanInfo != nil);
			  
	LoanPmtDigestEntry *loanPmt = [[[LoanPmtDigestEntry alloc] 
		initWithLoanInfo:self.loanInfo andPmtProcessor:self.pmtProcessor] autorelease];
		
	[digest.digestEntries addDigestEntry:loanPmt onDate:self.eventDate];
}




@end
