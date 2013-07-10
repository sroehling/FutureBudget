//
//  AssetSimInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AssetInput;
@class InterestBearingWorkingBalance;
@class SimParams;
@class InputValDigestSummation;
@class DigestEntryProcessingParams;

@interface AssetSimInfo : NSObject {
	@private
		AssetInput *asset;
		InterestBearingWorkingBalance *assetValue;
		SimParams *simParams;
		
		InputValDigestSummation *sumGainsLosses;
		InputValDigestSummation *assetSaleIncome;
		InputValDigestSummation *assetPurchaseExpense;
		
		NSDate *purchaseDate;
		NSDate *saleDate;
    
}

@property(nonatomic,retain) InterestBearingWorkingBalance *assetValue;
@property(nonatomic,retain) AssetInput *asset;
@property(nonatomic,retain) SimParams *simParams;
@property(nonatomic,retain) NSDate *purchaseDate;
@property(nonatomic,retain) NSDate *saleDate;

@property(nonatomic,retain) InputValDigestSummation *sumGainsLosses;
@property(nonatomic,retain) InputValDigestSummation *assetSaleIncome;
@property(nonatomic,retain) InputValDigestSummation *assetPurchaseExpense;

-(bool)purchasedAfterSimStart;
- (bool)soldAfterSimStart;
-(bool)ownedForAtLeastOneDay;
- (double)purchaseCost;

-(id)initWithAsset:(AssetInput*)theAsset andSimParams:(SimParams*)theSimParams;
-(void)processSale:(DigestEntryProcessingParams*)processingParams;

@end
