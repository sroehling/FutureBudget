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


@implementation LoanPaymentSimEvent

@synthesize interestIsTaxable;
@synthesize paymentAmt;
@synthesize interestAmt;


- (void)doSimEvent:(FiscalYearDigest*)digest
{
	NSString *currencyAmount = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.paymentAmt]];
				
	NSString *interestAmount = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.interestAmt]];
    
    NSLog(@"Doing loan payment event: %@  payment=%@,interest=%@",
          [[DateHelper theHelper].longDateFormatter stringFromDate:self.eventDate],
		  currencyAmount,interestAmount);
/*		  
	SavingsContribDigestEntry *savingsContrib = 
		[[[SavingsContribDigestEntry alloc] 
		initWithWorkingBalance:self.savingsBalance 
		andContribAmount:self.contributionAmount
		andIsTaxable:self.contributionIsTaxable] autorelease];
	[digest.cashFlowSummations addSavingsContrib:savingsContrib onDate:self.eventDate];
*/
}


@end
