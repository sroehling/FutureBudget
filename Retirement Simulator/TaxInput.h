//
//  TaxInput.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Input.h"

extern NSString * const TAX_INPUT_ENTITY_NAME;

@class ItemizedTaxAmts, MultiScenarioAmount, MultiScenarioGrowthRate, MultiScenarioInputValue, TaxBracket;

@interface TaxInput : Input {
@private
}

@property (nonatomic, retain) MultiScenarioAmount * exemptionAmt;
@property (nonatomic, retain) MultiScenarioGrowthRate * exemptionGrowthRate;
@property (nonatomic, retain) ItemizedTaxAmts * itemizedAdjustments;
@property (nonatomic, retain) ItemizedTaxAmts * itemizedCredits;
@property (nonatomic, retain) ItemizedTaxAmts * itemizedDeductions;
@property (nonatomic, retain) ItemizedTaxAmts * itemizedIncomeSources;
@property (nonatomic, retain) MultiScenarioAmount * stdDeductionAmt;
@property (nonatomic, retain) MultiScenarioGrowthRate * stdDeductionGrowthRate;
@property (nonatomic, retain) TaxBracket * taxBracket;
@property (nonatomic, retain) MultiScenarioInputValue * taxEnabled;

@end
