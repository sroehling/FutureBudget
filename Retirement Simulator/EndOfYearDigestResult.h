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
		BalanceAdjustment *totalInterest;
		BalanceAdjustment *totalWithdrawals;
		NSDate *endDate;
		double totalEndOfYearBalance;
}

@property(readonly) double totalIncome;
@property(nonatomic,retain) BalanceAdjustment *totalExpense;
@property(nonatomic,retain) BalanceAdjustment *totalInterest;
@property(nonatomic,retain) BalanceAdjustment *totalWithdrawals;
@property(nonatomic,retain) NSDate *endDate;
@property double totalEndOfYearBalance;

-(id)initWithEndDate:(NSDate*)endOfYearDate;

- (void)incrementTotalIncome:(double)incomeAmount;
- (void)incrementTotalExpense:(BalanceAdjustment*)theExpense;
- (void)incrementTotalInterest:(BalanceAdjustment*)theInterest;
- (void)incrementTotalWithdrawals:(BalanceAdjustment*)theWithdrawal;


- (NSInteger)yearNumber;

- (void)logResults;

@end
