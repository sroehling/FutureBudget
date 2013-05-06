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
@synthesize dividendAmount;

- (void) dealloc
{
	[acctSimInfo release];
	[super dealloc];

}


- (void)doSimEvent:(FiscalYearDigest*)digest
{
	NSString *formattedDivAmt = [[NumberHelper theHelper].currencyFormatter
				stringFromNumber:[NSNumber numberWithDouble:self.dividendAmount]];
   
    NSLog(@"Doing account dividend event: %@ %@ %@",
          self.acctSimInfo.account.name,
          [[DateHelper theHelper].longDateFormatter stringFromDate:self.eventDate],
		  formattedDivAmt);
		  
	AccountDividendDigestEntry *divDigestEntry =
		[[[AccountDividendDigestEntry alloc] initWithDividendAmount:self.dividendAmount] autorelease];
	[digest.digestEntries addDigestEntry:divDigestEntry onDate:self.eventDate];
		  
}




@end
