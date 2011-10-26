//
//  AssetPurchaseDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetPurchaseDigestEntry.h"

#import "DigestEntryProcessingParams.h"
#import "AssetSimInfo.h"
#import "InterestBearingWorkingBalance.h"
#import "WorkingBalanceMgr.h"

@implementation AssetPurchaseDigestEntry

-(void)processDigestEntry:(DigestEntryProcessingParams*)processingParams
{
	
	double purchaseCost = [self.assetInfo purchaseCost];
	
	[processingParams.workingBalanceMgr decrementBalanceFromFundingList:purchaseCost 
		asOfDate:processingParams.currentDate];
	[self.assetInfo.assetValue 
			incrementBalance:purchaseCost asOfDate:processingParams.currentDate];

}

@end
