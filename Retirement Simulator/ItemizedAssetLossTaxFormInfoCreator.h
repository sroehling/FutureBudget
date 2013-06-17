//
//  ItemizedAssetLossTaxFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/17/13.
//
//

#import <Foundation/Foundation.h>
#import "FormInfoCreator.h"

@class AssetInput;

@interface ItemizedAssetLossTaxFormInfoCreator : NSObject <FormInfoCreator> {
    @private
		AssetInput *asset;
		BOOL isForNewObject;

}

@property(nonatomic,retain) AssetInput *asset;
@property BOOL isForNewObject;

-(id)initWithAsset:(AssetInput*)theAsset andIsForNewObject:(BOOL)forNewObject;


@end
