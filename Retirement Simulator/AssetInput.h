//
//  AssetInput.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Input.h"

extern NSString * const ASSET_INPUT_ENTITY_NAME;
extern NSString * const INPUT_ASSET_STARTING_VALUE_KEY;
extern NSString * const ASSET_INPUT_DEFAULT_ICON_NAME;

@class MultiScenarioInputValue;
@class MultiScenarioGrowthRate;
@class MultiScenarioSimDate;
@class MultiScenarioSimEndDate;
@class MultiScenarioAmount;
@class AssetGainItemizedTaxAmt;
@class AssetLossItemizedTaxAmt;

@interface AssetInput : Input {
@private
}
@property (nonatomic, retain) NSNumber * startingValue;
@property (nonatomic, retain) MultiScenarioSimDate * purchaseDate;
@property (nonatomic, retain) MultiScenarioSimEndDate * saleDate;
@property (nonatomic, retain) MultiScenarioAmount * cost;
@property (nonatomic, retain) MultiScenarioGrowthRate * apprecRate;
@property (nonatomic, retain) MultiScenarioInputValue * assetEnabled;
@property (nonatomic, retain) NSSet *assetGainItemizedTaxAmts;
@property (nonatomic, retain) NSSet *assetLossItemizedTaxAmts;

@end

@interface AssetInput (CoreDataGeneratedAccessors)

- (void)addAssetGainItemizedTaxAmtsObject:(AssetGainItemizedTaxAmt *)value;
- (void)removeAssetGainItemizedTaxAmtsObject:(AssetGainItemizedTaxAmt *)value;
- (void)addAssetGainItemizedTaxAmts:(NSSet *)values;
- (void)removeAssetGainItemizedTaxAmts:(NSSet *)values;

- (void)addAssetLossItemizedTaxAmtsObject:(AssetLossItemizedTaxAmt *)value;
- (void)removeAssetLossItemizedTaxAmtsObject:(AssetLossItemizedTaxAmt *)value;
- (void)addAssetLossItemizedTaxAmts:(NSSet *)values;
- (void)removeAssetLossItemizedTaxAmts:(NSSet *)values;



@end
