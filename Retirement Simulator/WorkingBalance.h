//
//  WorkingBalance.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BalanceAdjustment;
@class WorkingBalanceAdjustment;

#define WORKING_BALANCE_WITHDRAW_PRIORITY_MAX 0.0

extern NSString * const WORKING_BALANCE_WITHDRAWAL_PRIORITY_KEY;

@interface WorkingBalance : NSObject {
    @protected
		NSDate *balanceStartDate;
		double startingBalance;
		double currentBalance;
		NSDate *currentBalanceDate;
		double withdrawPriority;
		NSDate *deferWithdrawalsUntil;
}

- (void) incrementBalance:(double)amount asOfDate:(NSDate*)newDate;
- (double) decrementAvailableBalance:(double)amount asOfDate:(NSDate*)newDate;
- (double)zeroOutBalanceAsOfDate:(NSDate*)newDate;

- (id) initWithStartingBalance:(double)theStartBalance 
	andStartDate:(NSDate*)theStartDate andWithdrawPriority:(double)theWithdrawPriority;
	
- (void)resetCurrentBalance;
- (void)advanceCurrentBalanceToDate:(NSDate*)newDate;
- (void)carryBalanceForward:(NSDate*)newStartDate;

- (NSString*)balanceName;
- (void)logBalance;

@property(nonatomic,retain) NSDate *balanceStartDate;
@property(nonatomic,retain) NSDate *currentBalanceDate;
@property(nonatomic,retain) NSDate *deferWithdrawalsUntil;
@property(readonly) double startingBalance;
@property(readonly) double currentBalance;
@property double withdrawPriority;

@end
