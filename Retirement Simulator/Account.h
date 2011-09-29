//
//  Account.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Input.h"

extern NSString * const ACCOUNT_STARTING_BALANCE_KEY;
extern NSString * const ACCOUNT_ENTITY_NAME;
extern NSString * const ACCOUNT_CONTRIB_AMOUNT_ENTITY_NAME;

extern NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_AMOUNT_KEY;
extern NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_GROWTH_RATE_KEY;
extern NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_REPEAT_FREQUENCY_KEY;
extern NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_START_DATE_KEY;
extern NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_END_DATE_KEY;
extern NSString * const ACCOUNT_VARIABLE_CONTRIB_AMOUNTS_KEY;
extern NSString * const ACCOUNT_MULTI_SCEN_DEFERRED_WITHDRAWAL_DATE_KEY;

@class VariableValue;
@class MultiScenarioInputValue;

@interface Account : Input {
@private
}
@property (nonatomic, retain) NSNumber * startingBalance;


@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioContribAmount;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioContribGrowthRate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioContribRepeatFrequency;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioContribStartDate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioContribEndDate;

@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioFixedContribAmount;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioFixedContribStartDate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioFixedContribEndDate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioFixedContribRelEndDate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioFixedContribGrowthRate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioContribEnabled;


// TBD - Depending on the final class structure of accounts, investments, etc., should
// the deferred withdrawal info be pushed into a dedicated class.
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioDeferredWithdrawalsEnabled;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioDeferredWithdrawalDate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioDeferredWithdrawalDateFixed;

@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioWithdrawalPriority;

@property (nonatomic,retain) NSSet* variableContribAmounts;

- (void)addVariableContribAmountsObject:(VariableValue *)value;

@end
