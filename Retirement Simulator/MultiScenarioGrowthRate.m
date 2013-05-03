//
//  MultiScenarioGrowthRate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioGrowthRate.h"
#import "MultiScenarioInputValue.h"

NSString * const MULTI_SCEN_GROWTH_RATE_ENTITY_NAME = @"MultiScenarioGrowthRate";

@implementation MultiScenarioGrowthRate
@dynamic growthRate;
@dynamic defaultFixedGrowthRate;

// Inverse relationships
@dynamic accountContribGrowthRate;
@dynamic accountInterestRate;
@dynamic accountDividendRate;
@dynamic assetApprecRate;
@dynamic taxExemptionGrowthRate;
@dynamic taxStdDeductionGrowthRate;
@dynamic cashFlowAmountGrowthRate;
@dynamic loanCostGrowthRate;
@dynamic loanExtraPmtGrowthRate;
@dynamic loanInterestRate;
@dynamic taxBracketCutoffGrowthRate;

@end
