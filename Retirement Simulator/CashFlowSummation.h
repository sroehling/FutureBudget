//
//  CashFlowSummation.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SavingsContribDigestEntry;
@class BalanceAdjustment;
@class LoanPmtDigestEntry;
@class AssetDigestEntry;
@class CashFlowDigestEntry;

@interface CashFlowSummation : NSObject {
    @private
		BalanceAdjustment *sumExpenses;
// TODO - Need to change name of sumIncome to sumGrossIncome if this name better represents the value
		double sumIncome;
		NSMutableArray *savingsContribs;
		NSMutableArray *loanPmts;
		NSMutableArray *assetPurchases;
		NSMutableArray *assetSales;
		NSMutableArray *incomeCashFlows;
		BalanceAdjustment *sumContributions;
		bool isEndDateForEstimatedTaxes;
		bool isEstimatedTaxPaymentDay;
}

- (void)addIncome:(CashFlowDigestEntry*)incomeDigestEntry;

- (void)addExpense:(BalanceAdjustment*)expenseAmount;
- (void) addSavingsContrib:(SavingsContribDigestEntry*)savingsContrib;
- (void)addLoanPmt:(LoanPmtDigestEntry*)theLoanPmt;
- (void)addAssetSale:(AssetDigestEntry*)assetEntry;
- (void)addAssetPurchase:(AssetDigestEntry*)assetEntry;


- (void)markAsEndDateForEstimatedTaxAccrual;
- (void)markAsEstimatedTaxPaymentDay;
- (void)resetSummations;

- (double)totalDeductions;

@property(nonatomic,retain) BalanceAdjustment *sumExpenses;
@property(readonly) double sumIncome;
@property(nonatomic,retain) NSMutableArray *savingsContribs;
@property(nonatomic,retain) NSMutableArray *loanPmts;
@property(nonatomic,retain) NSMutableArray *assetPurchases;
@property(nonatomic,retain) NSMutableArray *assetSales;
@property(nonatomic,retain) NSMutableArray *incomeCashFlows;
@property(nonatomic,retain) BalanceAdjustment *sumContributions;
@property(readonly) bool isEndDateForEstimatedTaxes;
@property(readonly) bool isEstimatedTaxPaymentDay;

@end
