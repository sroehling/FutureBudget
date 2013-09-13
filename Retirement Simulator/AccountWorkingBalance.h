//
//  InvestmentAccountWorkingBalance.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/8/13.
//
//

#import <Foundation/Foundation.h>

#include "WorkingBalance.h"

@class CashWorkingBalance;
@class InterestBearingWorkingBalance;
@class Account;
@class DateSensitiveValue;
@class InputValDigestSummation;
@class SimParams;
@class DateHelper;

@interface AccountWorkingBalance : NSObject <WorkingBalance> {
	@private
		InterestBearingWorkingBalance *overallBal; // overall account balance

		// The cost basis is the amount of money invested, including
		// contributions or re-invested dividends. The cost basis is
		// not adjusted for interest, so it can use the same type
		// of working balance as the cash balance elsewhere in the
		// simulator.
		CashWorkingBalance *costBasis;
		
		InputValDigestSummation *capitalGains;
		InputValDigestSummation *capitalLosses;


		NSDate *deferWithdrawalsUntil;
		NSSet *limitWithdrawalsToExpense;
		
		double withdrawPriority;
    
        DateHelper *dateHelper;
	
}

@property(nonatomic,retain) InterestBearingWorkingBalance *overallBal;
@property(nonatomic,retain) InputValDigestSummation *capitalGains;
@property(nonatomic,retain) InputValDigestSummation *capitalLosses;
@property(nonatomic,retain) CashWorkingBalance *costBasis;
@property(nonatomic,retain) NSDate *deferWithdrawalsUntil;
@property(nonatomic,retain) NSSet *limitWithdrawalsToExpense;
@property(nonatomic,retain) DateHelper *dateHelper;

@property double withdrawPriority;

- (id) initWithAcct:(Account*)theAcct andSimParams:(SimParams*)simParams;

// Initialize with raw inputs - intended for unit testing
-(id)initWithWithdrawalPriority:(double)theWithdrawPriority
	andStartDate:(NSDate*)theStartDate
	andStartingBal:(double)startingBal 	andInterestRate:(DateSensitiveValue*)theInterestRate
	andStartingCostBasis:(double)startingCostBasis andDeferWithdrawDate:(NSDate*)deferUntil
	andLimitedExpense:(NSSet*)limitedExpenses;

@end
