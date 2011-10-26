//
//  AssetSaleSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetSaleSimEvent.h"
#import "FiscalYearDigest.h"
#import "AssetSaleDigestEntry.h"
#import "FiscalYearDigest.h"
#import "CashFlowSummations.h"

@implementation AssetSaleSimEvent

- (void)doSimEvent:(FiscalYearDigest*)digest
{
	AssetSaleDigestEntry *assetEntry = [[[AssetSaleDigestEntry alloc] 
		initWithAssetSimInfo:self.assetSimInfo] autorelease];
	[digest.cashFlowSummations addDigestEntry:assetEntry onDate:self.eventDate];

}


@end
