//
//  EstimatedTaxPaymentSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EstimatedTaxPaymentSimEvent.h"
#import "DateHelper.h"
#import "FiscalYearDigest.h"
#import "FiscalYearDigestEntries.h"


@implementation EstimatedTaxPaymentSimEvent

- (void)doSimEvent:(FiscalYearDigest*)digest
{
	[digest.digestEntries markDateForEstimatedTaxPayment:self.eventDate];
}



@end
