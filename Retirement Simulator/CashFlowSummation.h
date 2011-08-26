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

@interface CashFlowSummation : NSObject {
    @private
		BalanceAdjustment *sumExpenses;
#warning TODO - Need to change name of sumIncome to sumGrossIncome if this name better represents the value
		double sumIncome;
		NSMutableArray *savingsContribs;
		BalanceAdjustment *sumContributions;
}

- (void)addIncome:(double)incomeAmount;
- (void)addExpense:(BalanceAdjustment*)expenseAmount;
- (void) addSavingsContrib:(SavingsContribDigestEntry*)savingsContrib;
- (void)resetSummations;

@property(nonatomic,retain) BalanceAdjustment *sumExpenses;
@property(readonly) double sumIncome;
@property(nonatomic,retain) NSMutableArray *savingsContribs;
@property(nonatomic,retain) BalanceAdjustment *sumContributions;


@end
