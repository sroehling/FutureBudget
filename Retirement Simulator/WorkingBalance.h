//
//  WorkingBalance.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/8/13.
//
//

#import <Foundation/Foundation.h>

@class ExpenseInput;

@protocol WorkingBalance <NSObject>

@property double withdrawPriority;


- (void)resetCurrentBalance;
- (void)advanceCurrentBalanceToDate:(NSDate*)newDate;
- (void)carryBalanceForward:(NSDate*)newStartDate;
- (double)currentBalanceForDate:(NSDate*)balanceDate;

-(BOOL)withdrawalsEnabledAsOfDate:(NSDate*)theDate;

- (double) decrementAvailableBalanceForExpense:(ExpenseInput*)expense 
	andAmount:(double)amount asOfDate:(NSDate*)newDate;
-(double)decrementAvailableBalanceForNonExpense:(double)amount 
	asOfDate:(NSDate *)newDate;

- (void) incrementBalance:(double)amount asOfDate:(NSDate*)newDate;

-(NSString*)balanceName;

@end
