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
		NSString *label;
}

@property(nonatomic,retain) AssetInput *asset;
@property(nonatomic,retain) NSString *label;

-(id)initWithAsset:(AssetInput*)theAsset andLabel:(NSString*)theLabel;

@end
