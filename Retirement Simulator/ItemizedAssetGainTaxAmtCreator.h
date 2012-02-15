//
//  ItemizedAssetGainTaxAmtCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AssetInput;
@class FormContext;

#import "ItemizedTaxAmtCreator.h"

@interface ItemizedAssetGainTaxAmtCreator : NSObject <ItemizedTaxAmtCreator> {
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
