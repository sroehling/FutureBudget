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
@class SavingsWorkingBalance;
@class BalanceAdjustment;


@interface WorkingBalanceMgr : NSObject {
	@private
		NSMutableArray *fundingSources;
#warning TODO - Need to reconsider supporting interest with cash working balance.
		CashWorkingBalance *cashWorkingBalance;
		SavingsWorkingBalance *deficitBalance;
		
}

@property(nonatomic,retain) NSMutableArray *fundingSources;
@property(nonatomic,retain) CashWorkingBalance *cashWorkingBalance;
@property(nonatomic,retain) SavingsWorkingBalance *deficitBalance;

- (id)initWithStartDate:(NSDate*)startDate;
- (id) initWithCashBalance:(CashWorkingBalance*)cashBal 
	andDeficitBalance:(SavingsWorkingBalance*)deficitBal;

- (void) addFundingSource:(WorkingBalance*)theBalance;
- (void)carryBalancesForward:(NSDate*)newDate;
- (void) resetCurrentBalances;

- (void) incrementCashBalance:(double)incomeAmount asOfDate:(NSDate*)newDate;
- (BalanceAdjustment*) decrementBalanceFromFundingList:(double)expenseAmount  asOfDate:(NSDate*)newDate;
- (double) decrementAvailableCashBalance:(double)expenseAmount asOfDate:(NSDate*)newDate;

- (void)logCurrentBalances;



@end
