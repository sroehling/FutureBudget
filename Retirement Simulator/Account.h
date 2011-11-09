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
extern NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_REPEAT_FREQUENCY_KEY;

@class MultiScenarioInputValue;
@class MultiScenarioGrowthRate;
@class MultiScenarioAmount;
@class MultiScenarioSimDate;
@class MultiScenarioSimEndDate;

@interface Account : Input {
@private
}
@property (nonatomic, retain) NSNumber * startingBalance;


@property(nonatomic,retain) MultiScenarioAmount *contribAmount;
@property(nonatomic,retain) MultiScenarioGrowthRate *contribGrowthRate;
@property(nonatomic,retain) MultiScenarioInputValue *contribRepeatFrequency;
@property(nonatomic,retain) MultiScenarioSimDate *contribStartDate;
@property(nonatomic,retain) MultiScenarioSimEndDate *contribEndDate;
@property (nonatomic, retain) MultiScenarioGrowthRate * interestRate;

@property(nonatomic,retain) MultiScenarioInputValue *contribEnabled;


// TBD - Depending on the final class structure of accounts, investments, etc., should
// the deferred withdrawal info be pushed into a dedicated class.
@property(nonatomic,retain) MultiScenarioInputValue *deferredWithdrawalsEnabled;
@property(nonatomic,retain) MultiScenarioSimDate *deferredWithdrawalDate;

@property(nonatomic,retain) MultiScenarioInputValue *withdrawalPriority;

// Inverse Relationships
@property (nonatomic, retain) NSSet* accountWithdrawalItemizedTaxAmt;
@property (nonatomic, retain) NSSet* accountInterestItemizedTaxAmt;
@property (nonatomic, retain) NSSet* accountContribItemizedTaxAmt;



@end
