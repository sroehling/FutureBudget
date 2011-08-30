//
//  EstimatedTaxAccrualSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EstimatedTaxAccrualSimEvent.h"
#import "FiscalYearDigest.h"
#import "CashFlowSummations.h"
#import "DateHelper.h"


@implementation EstimatedTaxAccrualSimEvent

- (void)doSimEvent:(FiscalYearDigest*)digest
{
	NSLog(@"Estimated tax accrual: %@ %@",
		[[DateHelper theHelper].longDateFormatter stringFromDate:self.eventDate],
		[self.eventDate description]);
	[digest.cashFlowSummations markEndDateForEstimatedTaxAccrual:self.eventDate];
}


@end
