//
//  WorkingBalanceList.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CashWorkingBalance;
@class InterestBearingWorkingBalance;
@class BalanceAdjustment;
@class WorkingBalanceAdjustment;

@class WorkingBalanceCltn;
@class Cash;
@class FixedValue;
@class ExpenseInput;


@interface WorkingBalanceMgr : NSObject {
	@private
		WorkingBalanceCltn *fundingSources;
		WorkingBalanceCltn *loanBalances;
		WorkingBalanceCltn *assetValues;

// TODO - Need to reconsider supporting interest with cash working balance.
		CashWorkingBalance *cashWorkingBalance;
		InterestBearingWorkingBalance *deficitBalance;
		CashWorkingBalance *accruedEstimatedTaxes;
		CashWorkingBalance *nextEstimatedTaxPayment;
		
}

@property(nonatomic,retain) WorkingBalanceCltn *fundingSources;
@property(nonatomic,retain) WorkingBalanceCltn *loanBalances;
@property(nonatomic,retain) WorkingBalanceCltn *assetValues;
@property(nonatomic,retain) CashWorkingBalance *cashWorkingBalance;
@property(nonatomic,retain) InterestBearingWorkingBalance *deficitBalance;

@property(nonatomic,retain) CashWorkingBalance *accruedEstimatedTaxes;
@property(nonatomic,retain) CashWorkingBalance *nextEstimatedTaxPayment;
		
- (id)initWithStartDate:(NSDate*)startDate andCashBal:(double)startingCashBal 
		andDeficitInterestRate:(FixedValue*)deficitRate 
		andDeficitBalance:(double)startingDeficitBal;	
- (id) initWithCashBalance:(CashWorkingBalance*)cashBal 
	andDeficitBalance:(InterestBearingWorkingBalance*)deficitBal
	andStartDate:(NSDate*)startDate;

- (void)incrementAccruedEstimatedTaxes:(double)taxAmount asOfDate:(NSDate*)theDate;
- (void)setAsideAccruedEstimatedTaxesForNextTaxPaymentAsOfDate:(NSDate*)theDate;
- (double)decrementNextEstimatedTaxPaymentAsOfDate:(NSDate*)theDate;


- (void)carryBalancesForward:(NSDate*)newDate;
- (void)advanceBalancesToDate:(NSDate*)newDate;
- (double)totalCurrentNetBalance:(NSDate*)currentDate;
- (void) resetCurrentBalances;

- (void) incrementCashBalance:(double)incomeAmount asOfDate:(NSDate*)newDate;
- (double) decrementBalanceFromFundingList:(double)expenseAmount  asOfDate:(NSDate*)newDate;
- (double) decrementBalanceFromFundingList:(double)expenseAmount  asOfDate:(NSDate*)newDate
	forExpense:(ExpenseInput*)expense;
- (double) decrementAvailableCashBalance:(double)expenseAmount asOfDate:(NSDate*)newDate;


@end
