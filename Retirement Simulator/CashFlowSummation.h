//
//  CashFlowSummation.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CashFlowSummation : NSObject {
    @private
		double sumExpenses;
		double sumIncome;
}

- (void)addIncome:(double)incomeAmount;
- (void)addExpense:(double)expenseAmount;
- (void)resetSummations;

@property(readonly) double sumExpenses;
@property(readonly) double sumIncome;

@end
