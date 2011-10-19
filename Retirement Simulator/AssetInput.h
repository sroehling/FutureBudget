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

@class MultiScenarioInputValue;
@class MultiScenarioGrowthRate;
@class MultiScenarioSimDate;
@class MultiScenarioSimEndDate;
@class MultiScenarioAmount;

@interface AssetInput : Input {
@private
}
@property (nonatomic, retain) NSNumber * startingValue;
@property (nonatomic, retain) MultiScenarioSimDate * purchaseDate;

@property (nonatomic, retain) MultiScenarioSimEndDate * saleDate;

// TODO - For all MultiScenarioAmount,MultiScenarioGrowthRate references, need to make them 
// required in the data model.

@property (nonatomic, retain) MultiScenarioAmount * cost;
@property (nonatomic, retain) MultiScenarioGrowthRate * apprecRate;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioAssetEnabled;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioSaleProceedsTaxable;

@end
