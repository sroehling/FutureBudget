//
//  SavingsAccount.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Account.h"

@class MultiScenarioInputValue;

extern NSString * const SAVINGS_ACCOUNT_ENTITY_NAME;
extern NSString * const SAVINGS_ACCOUNT_TAXABLE_CONTRIBUTIONS_KEY;
extern NSString * const SAVINGS_ACCOUNT_TAXABLE_WITHDRAWALS_KEY;
extern NSString * const SAVINGS_ACCOUNT_INTEREST_RATE_KEY;

@interface SavingsAccount : Account {
@private
}
@property (nonatomic, retain) NSNumber * taxableContributions;
@property (nonatomic, retain) NSNumber * taxableWithdrawals;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioInterestRate;
@property (nonatomic, retain) MultiScenarioInputValue * multiScenarioFixedInterestRate;

@end