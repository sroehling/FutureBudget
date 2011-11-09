//
//  MultiScenarioSimEndDate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioSimEndDate.h"
#import "MultiScenarioInputValue.h"

NSString * const MULTI_SCEN_SIM_END_DATE_ENTITY_NAME = @"MultiScenarioSimEndDate";
NSString * const MULTI_SCEN_SIM_END_DATE_SIM_DATE_KEY = @"simDate";

@implementation MultiScenarioSimEndDate

@dynamic defaultFixedSimDate;
@dynamic simDate;
@dynamic defaultFixedRelativeEndDate;

// Inverse relationshiops
@dynamic accountContribEndDate;
@dynamic assetSaleDate;
@dynamic cashFlowEndDate;





@end
