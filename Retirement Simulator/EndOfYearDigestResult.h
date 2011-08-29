//
//  EndOfYearDigestResult.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BalanceAdjustment;

@interface EndOfYearDigestResult : NSObject {
    @private
		double totalIncome;
		double totalIncomeTaxes;
		BalanceAdjustment *totalExpense;
		BalanceAdjustment *totalInterest;
		BalanceAdjustment *totalWithdrawals;
}

@property(readonly) double totalIncome;
@property(readonly) double totalIncomeTaxes;
@property(nonatomic,retain) BalanceAdjustment *totalExpense;
@property(nonatomic,retain) BalanceAdjustment *totalInterest;
@property(nonatomic,retain) BalanceAdjustment *totalWithdrawals;

- (void)incrementTotalIncome:(double)incomeAmount;
- (void)incrementTotalIncomeTaxes:(double)taxAmount;
- (void)incrementTotalExpense:(BalanceAdjustment*)theExpense;
- (void)incrementTotalInterest:(BalanceAdjustment*)theInterest;
- (void)incrementTotalWithdrawals:(BalanceAdjustment*)theWithdrawal;


-(double)totalTaxableWithdrawalsAndSavingsInterest;
-(double)totalDeductableExpenseAndContributions;

- (void)logResults;

@end
