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
extern NSString * const INPUT_ASSET_MULTI_SCEN_COST_KEY;
extern NSString * const INPUT_ASSET_STARTING_VALUE_KEY;
extern NSString * const INPUT_ASSET_MULTI_SCEN_APPREC_RATE_KEY;
extern NSString * const ASSET_MULTI_SCEN_SALE_DATE_KEY;
extern NSString * const ASSET_INPUT_MULTI_SCEN_PURCHASE_DATE_KEY;

@class MultiScenarioInputValue;
@class VariableValue;

@interface AssetInput : Input {
@private
}
@property (nonatomic, retain) NSNumber * startingValue;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioPurchaseDate;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioPurchaseDateFixed;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioSaleDate;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioSaleDateFixed;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioCost;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioCostFixed;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioApprecRate;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioApprecRateFixed;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioAssetEnabled;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioSaleProceedsTaxable;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioSaleDateRelativeFixed;


@property (nonatomic, retain) NSSet* variableAssetValues;

- (void)addVariableAssetValuesObject:(VariableValue *)value;

@end
