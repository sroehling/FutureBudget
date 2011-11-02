//
//  AssetSaleDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetSaleDigestEntry.h"
#import "AssetSimInfo.h"
#import "DigestEntryProcessingParams.h"
#import "InterestBearingWorkingBalance.h"
#import "CashWorkingBalance.h"
#import "WorkingBalanceMgr.h"


@implementation AssetSaleDigestEntry

-(void)processDigestEntry:(DigestEntryProcessingParams*)processingParams
{
	[self.assetInfo processSale:processingParams];
}

@end
