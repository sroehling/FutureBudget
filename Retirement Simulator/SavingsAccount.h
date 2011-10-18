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

@class MultiScenarioGrowthRate;

extern NSString * const SAVINGS_ACCOUNT_ENTITY_NAME;
extern NSString * const SAVINGS_ACCOUNT_TAXABLE_CONTRIBUTIONS_KEY;
extern NSString * const SAVINGS_ACCOUNT_TAXABLE_WITHDRAWALS_KEY;
extern NSString * const SAVINGS_ACCOUNT_TAXABLE_INTEREST_KEY;

@interface SavingsAccount : Account {
@private
}
@property (nonatomic, retain) NSNumber * taxableContributions;
@property (nonatomic, retain) NSNumber * taxableWithdrawals;
@property (nonatomic, retain) NSNumber * taxableInterest;
@property (nonatomic, retain) MultiScenarioGrowthRate * interestRate;

@end
