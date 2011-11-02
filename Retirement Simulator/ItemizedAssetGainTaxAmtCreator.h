//
//  ItemizedAssetGainTaxAmtCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AssetInput;

@interface ItemizedAssetGainTaxAmtCreator : NSObject {
    @private
		AssetInput *asset;
}

@property(nonatomic,retain) AssetInput *asset;

-(id)initWithAsset:(AssetInput*)theAsset;

@end
