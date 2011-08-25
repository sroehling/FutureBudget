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
		BalanceAdjustment *totalExpense;
}

@property(readonly) double totalIncome;
@property(nonatomic,retain) BalanceAdjustment *totalExpense;

- (void)incrementTotalIncome:(double)incomeAmount;
- (void)incrementTotalExpense:(BalanceAdjustment*)theExpense;

- (void)logResults;

@end
