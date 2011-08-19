//
//  WorkingBalanceList.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CashWorkingBalance;
@class WorkingBalance;


@interface WorkingBalanceMgr : NSObject {
	@private
		NSMutableArray *workingBalances;
		CashWorkingBalance *cashWorkingBalance;
		
}

@property(nonatomic,retain) NSMutableArray *workingBalances;
@property(nonatomic,retain) CashWorkingBalance *cashWorkingBalance;

- (id)initWithStartDate:(NSDate*)startDate;

- (void) addWorkingBalance:(WorkingBalance*)theBalance;
- (void)carryBalancesForward:(NSDate*)newDate;
- (void) resetCurrentBalances;

- (void) incrementBalance:(double)incomeAmount asOfDate:(NSDate*)newDate;
- (void) decrementBalance:(double)expenseAmount asOfDate:(NSDate*)newDate;
- (double) decrementAvailableCashBalance:(double)expenseAmount asOfDate:(NSDate*)newDate;



@end
