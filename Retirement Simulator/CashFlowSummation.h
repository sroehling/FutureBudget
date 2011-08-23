//
//  CashFlowSummation.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SavingsContribDigestEntry;

@interface CashFlowSummation : NSObject {
    @private
		double sumExpenses;
		double sumIncome;
		NSMutableArray *savingsContribs;
}

- (void)addIncome:(double)incomeAmount;
- (void)addExpense:(double)expenseAmount;
- (void) addSavingsContrib:(SavingsContribDigestEntry*)savingsContrib;
- (void)resetSummations;

@property(readonly) double sumExpenses;
@property(readonly) double sumIncome;
@property(nonatomic,retain) NSMutableArray *savingsContribs;

@end
