//
//  AssetSaleSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetSaleSimEvent.h"
#import "FiscalYearDigest.h"
#import "AssetDigestEntry.h"
#import "FiscalYearDigest.h"
#import "CashFlowSummations.h"

@implementation AssetSaleSimEvent

- (void)doSimEvent:(FiscalYearDigest*)digest
{
	AssetDigestEntry *assetEntry = [[[AssetDigestEntry alloc] 
		initWithAssetSimInfo:self.assetSimInfo] autorelease];
	[digest.cashFlowSummations addAssetSale:assetEntry onDate:self.eventDate];

}


@end