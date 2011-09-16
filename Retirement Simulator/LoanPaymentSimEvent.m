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
#import "CashFlowSummations.h"
#import "FiscalYearDigest.h"


@implementation LoanPaymentSimEvent

@synthesize loanBalance;
@synthesize paymentAmt;



- (void)doSimEvent:(FiscalYearDigest*)digest
{
	NSString *pmtAmount = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.paymentAmt]];
				
    NSLog(@"Doing loan payment event: %@  payment=%@",
          [[DateHelper theHelper].longDateFormatter stringFromDate:self.eventDate],
		  pmtAmount);
		  
	LoanPmtDigestEntry *loanPmt = [[[LoanPmtDigestEntry alloc] 
		initWithBalance:self.loanBalance andPayment:self.paymentAmt] autorelease];
	[digest.cashFlowSummations addLoanPmt:loanPmt onDate:self.eventDate];
}


- (void)dealloc
{
	[super dealloc];
	[loanBalance release];
}


@end
