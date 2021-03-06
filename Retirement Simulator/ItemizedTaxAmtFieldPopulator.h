//
//  ItemizedTaxAmtFieldPopulator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ItemizedTaxAmtVisitor.h"

@class ItemizedTaxAmts;
@class IncomeItemizedTaxAmt;
@class ExpenseItemizedTaxAmt;
@class AccountWithdrawalItemizedTaxAmt;
@class AccountContribItemizedTaxAmt;
@class AssetGainItemizedTaxAmt;
@class AccountInterestItemizedTaxAmt;
@class LoanInterestItemizedTaxAmt;
@class ExpenseInput;
@class IncomeInput;
@class Account;
@class AssetInput;
@class LoanInput;
@class TaxInput;
@class DataModelController;

@interface ItemizedTaxAmtFieldPopulator : NSObject <ItemizedTaxAmtVisitor> {
	@private
		ItemizedTaxAmts *itemizedTaxAmts;
		DataModelController *dataModelController;
		
		NSMutableArray *itemizedIncomes;
		NSMutableArray *itemizedExpenses;
		NSMutableArray *itemizedAccountInterest;
		NSMutableArray *itemizedAccountDividend;
		NSMutableArray *itemizedAccountCapitalGain;
		NSMutableArray *itemizedAccountCapitalLoss;
		NSMutableArray *itemizedAccountContribs;
		NSMutableArray *itemizedAccountWithdrawals;
		NSMutableArray *itemizedAssets;
		NSMutableArray *itemizedAssetLosses;
		NSMutableArray *itemizedLoans;
		NSMutableArray *itemizedTaxesPaid;
}


@property(nonatomic,retain) ItemizedTaxAmts *itemizedTaxAmts;
@property(nonatomic,retain) DataModelController *dataModelController;

@property(nonatomic,retain) NSMutableArray *itemizedIncomes;
@property(nonatomic,retain) NSMutableArray *itemizedExpenses;
@property(nonatomic,retain) NSMutableArray *itemizedAccountInterest;
@property(nonatomic,retain) NSMutableArray *itemizedAccountDividend;
@property(nonatomic,retain) NSMutableArray *itemizedAccountCapitalGain;
@property(nonatomic,retain) NSMutableArray *itemizedAccountCapitalLoss;

@property(nonatomic,retain) NSMutableArray *itemizedAccountContribs;
@property(nonatomic,retain) NSMutableArray *itemizedAccountWithdrawals;
@property(nonatomic,retain) NSMutableArray *itemizedAssets;
@property(nonatomic,retain) NSMutableArray *itemizedAssetLosses;
@property(nonatomic,retain) NSMutableArray *itemizedLoans;
@property(nonatomic,retain) NSMutableArray *itemizedTaxesPaid;

-(id)initWithDataModelController:(DataModelController*)theDataModelController 
	andItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts;

- (NSArray*)incomesNotAlreadyItemized;
- (NSArray*)expensesNotAlreadyItemized;
- (NSArray*)acctWithdrawalsNotAlreadyItemized;
- (NSArray*)acctContribsNotAlreadyItemized;
- (NSArray*)acctInterestNotAlreadyItemized;
- (NSArray*)acctDividendNotAlreadyItemized;
- (NSArray*)acctCapitalGainNotAlreadyItemized;
- (NSArray*)acctCapitalLossNotAlreadyItemized;

- (NSArray*)assetGainsNotAlreadyItemized;
- (NSArray*)assetLossesNotAlreadyItemized;

- (NSArray*)loanInterestNotAlreadyItemized;
- (NSArray*)taxesPaidNotAlreadyItemizedExcluding:(TaxInput*)taxToExclude;

- (IncomeItemizedTaxAmt*)findItemizedIncome:(IncomeInput*)income;

- (ExpenseItemizedTaxAmt*)findItemizedExpense:(ExpenseInput*)expense;

- (AccountWithdrawalItemizedTaxAmt *)findItemizedAcctWithdrawal:(Account*)account;
- (AccountContribItemizedTaxAmt *)findItemizedAcctContrib:(Account*)account;
-(AccountInterestItemizedTaxAmt *)findItemizedAcctInterest:(Account*)account;
-(AccountDividendItemizedTaxAmt *)findItemizedAcctDividend:(Account*)account;
-(AccountCapitalGainItemizedTaxAmt *)findItemizedAcctCapitalGain:(Account*)account;
-(AccountCapitalLossItemizedTaxAmt *)findItemizedAcctCapitalLoss:(Account*)account;


-(AssetGainItemizedTaxAmt *)findItemizedAssetGain:(AssetInput*)asset;
-(AssetLossItemizedTaxAmt *)findItemizedAssetLoss:(AssetInput*)asset;

-(LoanInterestItemizedTaxAmt *)findItemizedLoanInterest:(LoanInput*)loan;

-(NSString*)itemizationSummary;
-(NSString*)itemizationCountSummary;
-(NSUInteger)itemizationCount;

@end
