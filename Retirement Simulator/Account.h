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
extern NSString * const ACCOUNT_COST_BASIS_KEY;
extern NSString * const ACCOUNT_ENTITY_NAME;
extern NSString * const ACCOUNT_INPUT_DEFAULT_ICON_NAME;

@class MultiScenarioInputValue;
@class MultiScenarioGrowthRate;
@class MultiScenarioAmount;
@class MultiScenarioSimDate;
@class MultiScenarioSimEndDate;
@class ExpenseInput;
@class TransferEndpointAcct;
@class AccountDividendItemizedTaxAmt;
@class AccountContribItemizedTaxAmt;
@class AccountInterestItemizedTaxAmt;
@class AccountWithdrawalItemizedTaxAmt;
@class AccountCapitalGainItemizedTaxAmt;
@class AccountCapitalLossItemizedTaxAmt;
@class MultiScenarioPercent;

@interface Account : Input {
@private
}
@property (nonatomic, retain) NSNumber * startingBalance;
@property (nonatomic, retain) NSNumber * costBasis;


@property(nonatomic,retain) MultiScenarioAmount *contribAmount;
@property(nonatomic,retain) MultiScenarioGrowthRate *contribGrowthRate;
@property(nonatomic,retain) MultiScenarioInputValue *contribRepeatFrequency;
@property(nonatomic,retain) MultiScenarioSimDate *contribStartDate;
@property(nonatomic,retain) MultiScenarioSimEndDate *contribEndDate;
@property (nonatomic, retain) MultiScenarioGrowthRate * interestRate;

@property (nonatomic, retain) MultiScenarioGrowthRate *dividendRate;
@property (nonatomic, retain) MultiScenarioPercent *dividendReinvestPercent;

@property(nonatomic,retain) MultiScenarioInputValue *contribEnabled;


// TBD - Depending on the final class structure of accounts, investments, etc., should
// the deferred withdrawal info be pushed into a dedicated class.
@property(nonatomic,retain) MultiScenarioInputValue *deferredWithdrawalsEnabled;
@property(nonatomic,retain) MultiScenarioSimDate *deferredWithdrawalDate;

@property(nonatomic,retain) MultiScenarioInputValue *withdrawalPriority;

// If there are expenses in limitWithdrawalExpenses, then only expenses in the
// set can cause a withdrawal to occur. This is needed to support targeted
// savings accounts, such as for health care, education, etc.
@property (nonatomic, retain) NSSet* limitWithdrawalExpenses;

// Inverse Relationships
@property (nonatomic, retain) NSSet* accountWithdrawalItemizedTaxAmt;
@property (nonatomic, retain) NSSet* accountInterestItemizedTaxAmt;
@property (nonatomic, retain) NSSet* accountContribItemizedTaxAmt;
@property (nonatomic, retain) TransferEndpointAcct *acctTransferEndpointAcct;
@property (nonatomic, retain) NSSet *accountDividendItemizedTaxAmt;

@property (nonatomic, retain) NSSet *accountCapitalGainItemizedTaxAmt;
@property (nonatomic, retain) NSSet *accountCapitalLossItemizedTaxAmt;



@end


@interface Account (CoreDataGeneratedAccessors)

- (void)addAccountCapitalGainItemizedTaxAmtObject:(AccountCapitalGainItemizedTaxAmt *)value;
- (void)removeAccountCapitalGainItemizedTaxAmtObject:(AccountCapitalGainItemizedTaxAmt *)value;
- (void)addAccountCapitalGainItemizedTaxAmt:(NSSet *)values;
- (void)removeAccountCapitalGainItemizedTaxAmt:(NSSet *)values;

- (void)addAccountCapitalLossItemizedTaxAmtObject:(AccountCapitalLossItemizedTaxAmt *)value;
- (void)removeAccountCapitalLossItemizedTaxAmtObject:(AccountCapitalLossItemizedTaxAmt *)value;
- (void)addAccountCapitalLossItemizedTaxAmt:(NSSet *)values;
- (void)removeAccountCapitalLossItemizedTaxAmt:(NSSet *)values;


- (void)addLimitWithdrawalExpensesObject:(ExpenseInput *)value;
- (void)removeLimitWithdrawalExpensesObject:(ExpenseInput *)value;
- (void)addLimitWithdrawalExpenses:(NSSet *)values;
- (void)removeLimitWithdrawalExpenses:(NSSet *)values;

- (void)addAccountContribItemizedTaxAmtObject:(AccountContribItemizedTaxAmt *)value;
- (void)removeAccountContribItemizedTaxAmtObject:(AccountContribItemizedTaxAmt *)value;
- (void)addAccountContribItemizedTaxAmt:(NSSet *)values;
- (void)removeAccountContribItemizedTaxAmt:(NSSet *)values;

- (void)addAccountDividendItemizedTaxAmtObject:(AccountDividendItemizedTaxAmt *)value;
- (void)removeAccountDividendItemizedTaxAmtObject:(AccountDividendItemizedTaxAmt *)value;
- (void)addAccountDividendItemizedTaxAmt:(NSSet *)values;
- (void)removeAccountDividendItemizedTaxAmt:(NSSet *)values;

- (void)addAccountInterestItemizedTaxAmtObject:(AccountInterestItemizedTaxAmt *)value;
- (void)removeAccountInterestItemizedTaxAmtObject:(AccountInterestItemizedTaxAmt *)value;
- (void)addAccountInterestItemizedTaxAmt:(NSSet *)values;
- (void)removeAccountInterestItemizedTaxAmt:(NSSet *)values;

- (void)addAccountWithdrawalItemizedTaxAmtObject:(AccountWithdrawalItemizedTaxAmt *)value;
- (void)removeAccountWithdrawalItemizedTaxAmtObject:(AccountWithdrawalItemizedTaxAmt *)value;
- (void)addAccountWithdrawalItemizedTaxAmt:(NSSet *)values;
- (void)removeAccountWithdrawalItemizedTaxAmt:(NSSet *)values;


@end
