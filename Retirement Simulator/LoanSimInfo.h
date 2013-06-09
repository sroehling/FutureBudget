//
//  LoanSimInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoanInput;
@class InterestBearingWorkingBalance;
@class EventRepeater;
@class VariableRateCalculator;
@class SimParams;
@class LoanSimConfigParams;

@interface LoanSimInfo : NSObject {
    @private
		LoanInput *loan;
		SimParams *simParams;
		InterestBearingWorkingBalance *loanBalance;
		VariableRateCalculator *extraPmtGrowthCalc;
		
		double currentMonthlyPayment;

}

-(id)initWithLoan:(LoanInput*)theLoan andSimParams:(SimParams*)theParams;

-(bool)loanOriginatesAfterSimStart;

@property(nonatomic,retain) LoanInput *loan;
@property(nonatomic,retain) InterestBearingWorkingBalance *loanBalance;
@property(nonatomic,retain) VariableRateCalculator *extraPmtGrowthCalc;
@property(nonatomic,retain) SimParams *simParams;

// This property is initialized and updated during simulation to contain the
// current monthly payment. By default, the current monthly payment is set
// in LoanPaymentSimEventCreator to be the monthly payment based upon the
// loan origination amount. However, it may also be updated in
// FirstDeferredPaymentAmtCalculator to reflect the payment based upon the
// loan balance as of the first deferred payment (possibly including any accrued
// interest between the time of origination and the first payment).
@property double currentMonthlyPayment;


-(double)downPaymentAmount;
-(NSDate*)loanOrigDate;
- (double)startingBalanceAfterDownPayment; // Starting balance on the date of loan origination

-(NSDate*)earlyPayoffDate;
-(bool)earlyPayoffAfterOrigination;
- (bool)earlyPayoffAfterSimStart;
-(BOOL)deferredPaymentDateEnabled;
-(BOOL)deferredPaymentPayInterestWhileInDeferrment;
-(BOOL)deferredPaymentInterestSubsidized;
-(BOOL)beforeDeferredPaymentDate:(NSDate*)pmtDate;

- (double)loanOrigAmount;

- (EventRepeater*)createLoanPmtRepeater;

- (double)monthlyPaymentForPaymentsStartingAtLoanOrig;
-(double)monthlyPaymentForPmtCalcDate:(NSDate*)pmtCalcDate andStartingBal:(double)startingBal;

- (double)extraPmtAmountAsOfDate:(NSDate*)pmtDate;

-(LoanSimConfigParams*)configParamsForLoanOrigination;

@end
