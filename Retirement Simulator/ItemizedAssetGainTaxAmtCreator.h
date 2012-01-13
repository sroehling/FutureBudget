//
//  ItemizedAssetGainTaxAmtCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AssetInput;

#import "ItemizedTaxAmtCreator.h"

@interface ItemizedAssetGainTaxAmtCreator : NSObject <ItemizedTaxAmtCreator> {
    @private
		AssetInput *asset;
}

@property(nonatomic,retain) AssetInput *asset;

-(id)initWithAsset:(AssetInput*)theAsset;

@end
