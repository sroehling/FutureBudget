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
@class InterestBearingWorkingBalance;
@class BalanceAdjustment;
@class WorkingBalanceAdjustment;


@interface WorkingBalanceMgr : NSObject {
	@private
		NSMutableArray *fundingSources;
#warning TODO - Need to reconsider supporting interest with cash working balance.
		CashWorkingBalance *cashWorkingBalance;
		InterestBearingWorkingBalance *deficitBalance;
		CashWorkingBalance *accruedEstimatedTaxes;
		CashWorkingBalance *nextEstimatedTaxPayment;
		
}

@property(nonatomic,retain) NSMutableArray *fundingSources;
@property(nonatomic,retain) CashWorkingBalance *cashWorkingBalance;
@property(nonatomic,retain) InterestBearingWorkingBalance *deficitBalance;

@property(nonatomic,retain) CashWorkingBalance *accruedEstimatedTaxes;
@property(nonatomic,retain) CashWorkingBalance *nextEstimatedTaxPayment;

- (id)initWithStartDate:(NSDate*)startDate;
- (id) initWithCashBalance:(CashWorkingBalance*)cashBal 
	andDeficitBalance:(InterestBearingWorkingBalance*)deficitBal
	andStartDate:(NSDate*)startDate;

- (void)incrementAccruedEstimatedTaxes:(double)taxAmount asOfDate:(NSDate*)theDate;
- (void)setAsideAccruedEstimatedTaxesForNextTaxPaymentAsOfDate:(NSDate*)theDate;
- (double)decrementNextEstimatedTaxPaymentAsOfDate:(NSDate*)theDate;


- (void) addFundingSource:(WorkingBalance*)theBalance;
- (void)carryBalancesForward:(NSDate*)newDate;
- (BalanceAdjustment*)advanceBalancesToDate:(NSDate*)newDate;
- (double)totalCurrentBalance;
- (void) resetCurrentBalances;

- (void) incrementCashBalance:(double)incomeAmount asOfDate:(NSDate*)newDate;
- (WorkingBalanceAdjustment*) decrementBalanceFromFundingList:(double)expenseAmount  asOfDate:(NSDate*)newDate;
- (double) decrementAvailableCashBalance:(double)expenseAmount asOfDate:(NSDate*)newDate;

- (void)logCurrentBalances;



@end
