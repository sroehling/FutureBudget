//
//  FiscalYearDigest.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CashWorkingBalance;

@interface FiscalYearDigest : NSObject {
    @private
		NSArray *cashFlowSummations;
		NSDate *startDate;
		CashWorkingBalance *cashWorkingBalance;
}

-(id)initWithStartDate:(NSDate*)theStartDate;

- (void)addExpense:(double)amount onDate:(NSDate*)expenseDate;
- (void)addIncome:(double)amount onDate:(NSDate*)incomeDate;
- (void)advanceToNextYear;

@property(nonatomic,retain) NSDate *startDate;

@property(nonatomic,retain) CashWorkingBalance *cashWorkingBalance;

@end
