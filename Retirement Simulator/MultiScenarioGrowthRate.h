//
//  MultiScenarioGrowthRate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const MULTI_SCEN_GROWTH_RATE_ENTITY_NAME;
extern NSString * const MULTI_SCEN_GROWTH_RATE_GROWTH_RATE_KEY;

@class MultiScenarioInputValue;

@class Account;
@class AssetInput;
@class TaxInput;
@class CashFlowInput;
@class LoanInput;
@class MultiScenarioGrowthRate;

@interface MultiScenarioGrowthRate : NSManagedObject {
@private
}
@property (nonatomic, retain) MultiScenarioInputValue * growthRate;
@property (nonatomic, retain) MultiScenarioInputValue * defaultFixedGrowthRate;

// Inverse relationships
@property (nonatomic, retain) Account * accountContribGrowthRate;
@property (nonatomic, retain) Account * accountInterestRate;
@property (nonatomic, retain) AssetInput * assetApprecRate;
@property (nonatomic, retain) TaxInput * taxExemptionGrowthRate;
@property (nonatomic, retain) TaxInput * taxStdDeductionGrowthRate;
@property (nonatomic, retain) CashFlowInput * cashFlowAmountGrowthRate;
@property (nonatomic, retain) LoanInput * loanCostGrowthRate;
@property (nonatomic, retain) LoanInput * loanExtraPmtGrowthRate;
@property (nonatomic, retain) LoanInput * loanInterestRate;


@end
