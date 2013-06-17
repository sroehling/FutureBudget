//
//  AssetLossItemizedTaxAmt.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/17/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemizedTaxAmt.h"

@class AssetInput;

extern NSString * const ASSET_LOSS_ITEMIZED_TAX_AMT_ENTITY_NAME;

@interface AssetLossItemizedTaxAmt : ItemizedTaxAmt

@property (nonatomic, retain) AssetInput *asset;

@end
