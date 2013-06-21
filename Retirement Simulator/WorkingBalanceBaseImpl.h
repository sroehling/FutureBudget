//
//  WorkingBalance.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WorkingBalance.h"

@class BalanceAdjustment;
@class WorkingBalanceAdjustment;
@class InputValDigestSummation;
@class ExpenseInput;

#define WORKING_BALANCE_WITHDRAW_PRIORITY_MAX 0.0


@interface WorkingBalanceBaseImpl : NSObject <WorkingBalance> {
    @protected
		NSDate *balanceStartDate;
		double startingBalance;
		double currentBalance;
		NSDate *currentBalanceDate;
		
		double withdrawPriority;
		
		InputValDigestSummation *contribs;
		InputValDigestSummation *withdrawals;


}

- (void) incrementBalance:(double)amount asOfDate:(NSDate*)newDate;

- (double) decrementAvailableBalanceForNonExpense:(double)amount 
		asOfDate:(NSDate*)newDate;
- (double) decrementAvailableBalanceForExpense:(ExpenseInput*)expense andAmount:(double)amount asOfDate:(NSDate*)newDate;
	
- (double)zeroOutBalanceAsOfDate:(NSDate*)newDate;

- (id) initWithStartingBalance:(double)theStartBalance 
	andStartDate:(NSDate*)theStartDate andWithdrawPriority:(double)theWithdrawPriority;
	
- (void)resetCurrentBalance;
- (void)advanceCurrentBalanceToDate:(NSDate*)newDate;
- (void)carryBalanceForward:(NSDate*)newStartDate;

- (double)currentBalanceForDate:(NSDate*)balanceDate;

- (NSString*)balanceName;

@property(nonatomic,retain) NSDate *balanceStartDate;
@property(nonatomic,retain) NSDate *currentBalanceDate;


@property(readonly) double startingBalance;
@property double currentBalance;
@property double withdrawPriority;

@property(nonatomic,retain) InputValDigestSummation *contribs;
@property(nonatomic,retain) InputValDigestSummation *withdrawals;

@end
