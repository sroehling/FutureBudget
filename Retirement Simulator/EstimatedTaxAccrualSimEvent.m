//
//  EstimatedTaxAccrualSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EstimatedTaxAccrualSimEvent.h"
#import "FiscalYearDigest.h"
#import "FiscalYearDigestEntries.h"
#import "DateHelper.h"


@implementation EstimatedTaxAccrualSimEvent

- (void)doSimEvent:(FiscalYearDigest*)digest
{
	[digest.digestEntries markEndDateForEstimatedTaxAccrual:self.eventDate];
}


@end
