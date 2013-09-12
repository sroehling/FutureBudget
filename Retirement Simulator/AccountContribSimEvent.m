//
//  SavingsContributionSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountContribSimEvent.h"
#import "DateHelper.h"
#import "NumberHelper.h"
#import "Account.h"
#import "FiscalYearDigest.h"
#import "AccountContribDigestEntry.h"
#import "FiscalYearDigestEntries.h"
#import "AccountSimInfo.h"


@implementation AccountContribSimEvent

@synthesize acctSimInfo;
@synthesize contributionAmount;

- (void)doSimEvent:(FiscalYearDigest*)digest
{    		  
	AccountContribDigestEntry *acctContrib = 
		[[[AccountContribDigestEntry alloc] 
		initWithAcctSimInfo:self.acctSimInfo
		andContribAmount:self.contributionAmount] autorelease];
	[digest.digestEntries addDigestEntry:acctContrib onDate:self.eventDate];
}


- (void) dealloc
{
	[acctSimInfo release];
	[super dealloc];

}

@end
