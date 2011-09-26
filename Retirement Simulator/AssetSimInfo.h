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

@interface AssetSimInfo : NSObject {
	@private
		AssetInput *asset;
		InterestBearingWorkingBalance *assetValue;
		SimParams *simParams;
		
		NSDate *purchaseDate;
		NSDate *saleDate;
    
}

@property(nonatomic,retain) InterestBearingWorkingBalance *assetValue;
@property(nonatomic,retain) AssetInput *asset;
@property(nonatomic,retain) SimParams *simParams;
@property(nonatomic,retain) NSDate *purchaseDate;
@property(nonatomic,retain) NSDate *saleDate;

-(bool)purchasedAfterSimStart;
- (bool)soldAfterSimStart;
-(bool)ownedForAtLeastOneDay;
- (double)purchaseCost;

-(id)initWithAsset:(AssetInput*)theAsset andSimParams:(SimParams*)theSimParams;

@end
