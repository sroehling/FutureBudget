//
//  FiscalYearDigest.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CashWorkingBalance;
@class WorkingBalanceMgr;
@class SavingsContribDigestEntry;

@interface FiscalYearDigest : NSObject {
    @private
		NSArray *cashFlowSummations;
		NSDate *startDate;
		WorkingBalanceMgr *workingBalanceMgr;
}

-(id)initWithStartDate:(NSDate*)theStartDate andWorkingBalances:(WorkingBalanceMgr*)wbMgr;

- (void)addExpense:(double)amount onDate:(NSDate*)expenseDate;
- (void)addIncome:(double)amount onDate:(NSDate*)incomeDate;
- (void)addSavingsContrib:(SavingsContribDigestEntry*)savingsContrib onDate:(NSDate*)contribDate;
- (void)advanceToNextYear;

@property(nonatomic,retain) NSDate *startDate;
@property(nonatomic,retain) WorkingBalanceMgr *workingBalanceMgr;


@end
