//
//  AssetGainItemizedTaxAmt.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemizedTaxAmt.h"

@class AssetInput;

extern NSString * const ASSET_GAIN_ITEMIZED_TAX_AMT_ENTITY_NAME;

@interface AssetGainItemizedTaxAmt : ItemizedTaxAmt {
@private
}
@property (nonatomic, retain) AssetInput * asset;


@end
