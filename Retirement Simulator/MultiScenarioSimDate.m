//
//  MultiScenarioSimDate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioSimDate.h"
#import "MultiScenarioInputValue.h"

NSString * const MULTI_SCEN_SIM_DATE_ENTITY_NAME = @"MultiScenarioSimDate";
NSString * const MULTI_SCEN_SIM_DATE_SIM_DATE_KEY = @"simDate";

@implementation MultiScenarioSimDate
@dynamic simDate;
@dynamic defaultFixedSimDate;

// Inverse relationships
@dynamic accountContribStartDate;
@dynamic accountDeferredWithdrawalDate;
@dynamic assetPurchaseDate;
@dynamic cashFlowStartDate;
@dynamic loanOrigDate;



@end
