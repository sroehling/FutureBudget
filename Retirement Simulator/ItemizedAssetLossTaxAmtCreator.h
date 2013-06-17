//
//  ItemizedAssetLossTaxAmtCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/17/13.
//
//

#import <Foundation/Foundation.h>
#import "ItemizedTaxAmtCreator.h"

@class FormContext;
@class AssetInput;

@interface ItemizedAssetLossTaxAmtCreator : NSObject <ItemizedTaxAmtCreator> {
    @private
		FormContext *formContext;
		AssetInput *asset;
		NSString *label;
}

@property(nonatomic,retain) AssetInput *asset;
@property(nonatomic,retain) NSString *label;
@property(nonatomic,retain) FormContext *formContext;

-(id)initWithFormContext:(FormContext*)theFormContext
	andAsset:(AssetInput*)theAsset andLabel:(NSString*)theLabel;

@end
