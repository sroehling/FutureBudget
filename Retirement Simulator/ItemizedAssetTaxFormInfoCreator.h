//
//  ItemizedAssetTaxFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class AssetInput;

@interface ItemizedAssetTaxFormInfoCreator : NSObject <FormInfoCreator> {
    @private
		AssetInput *asset;
		BOOL isForNewObject;

}

@property(nonatomic,retain) AssetInput *asset;
@property BOOL isForNewObject;

-(id)initWithAsset:(AssetInput*)theAsset andIsForNewObject:(BOOL)forNewObject;

@end
