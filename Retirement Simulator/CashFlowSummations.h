//
//  CashFlowSummations.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BalanceAdjustment;
@class SavingsContribDigestEntry;
@class CashFlowSummation;
@class LoanPmtDigestEntry;
@class AssetDigestEntry;
@class CashFlowDigestEntry;
@class InputValDigestSummation;

@interface CashFlowSummations : NSObject {
    @private
		NSArray *cashFlowSummations;
		NSDate *startDate;
		CashFlowSummation *yearlySummation;
    
}

-(id)initWithStartDate:(NSDate*)startDate;

- (void)addExpense:(BalanceAdjustment*)amount onDate:(NSDate*)expenseDate;

- (void)addIncome:(CashFlowDigestEntry*)incomeEntry onDate:(NSDate*)incomeDate;
- (void)addSavingsContrib:(SavingsContribDigestEntry*)savingsContrib onDate:(NSDate*)contribDate;
- (void)addLoanPmt:(LoanPmtDigestEntry*)loanPmt onDate:(NSDate*)pmtDate;
- (void)addAssetSale:(AssetDigestEntry*)assetEntry onDate:(NSDate*)purchaseDate;
- (void)addAssetPurchase:(AssetDigestEntry*)assetEntry onDate:(NSDate*)purchaseDate;

- (void)markEndDateForEstimatedTaxAccrual:(NSDate*)taxEndDate;
- (void)markDateForEstimatedTaxPayment:(NSDate*)taxPaymentDate;

- (void)resetSummations;
- (CashFlowSummation*)summationForDayIndex:(NSInteger)dayIndex;
- (CashFlowSummation*)summationForDate:(NSDate*)eventDate;
- (void)resetSummationsAndAdvanceStartDate:(NSDate*)newStartDate;


@property(nonatomic,retain) NSDate *startDate;
@property(nonatomic,retain) CashFlowSummation *yearlySummation;

@end
