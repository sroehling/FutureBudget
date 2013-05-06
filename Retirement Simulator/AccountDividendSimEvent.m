//
//  AccountDividendSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/13.
//
//

#import "AccountDividendSimEvent.h"
#import "NumberHelper.h"
#import "DateHelper.h"
#import "Account.h"
#import "InterestBearingWorkingBalance.h"
#import "FiscalYearDigest.h"
#import "FiscalYearDigestEntries.h"
#import "AccountSimInfo.h"
#import "AccountDividendDigestEntry.h"

@implementation AccountDividendSimEvent

@synthesize acctSimInfo;

- (void) dealloc
{
	[acctSimInfo release];
	[super dealloc];

}


- (void)doSimEvent:(FiscalYearDigest*)digest
{
	AccountDividendDigestEntry *divDigestEntry =
		[[[AccountDividendDigestEntry alloc] initWithAcctSimInfo:self.acctSimInfo] autorelease];
	[digest.digestEntries addDigestEntry:divDigestEntry onDate:self.eventDate];		  
}




@end
