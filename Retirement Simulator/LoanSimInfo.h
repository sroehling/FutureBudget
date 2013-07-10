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
@class PeriodicInterestBearingWorkingBalance;
@class EventRepeater;
@class VariableRateCalculator;
@class InputValDigestSummation;
@class SimParams;

@interface LoanSimInfo : NSObject {
    @private
		LoanInput *loan;
		SimParams *simParams;
		PeriodicInterestBearingWorkingBalance *loanBalance;
		VariableRateCalculator *extraPmtGrowthCalc;
		InputValDigestSummation *downPaymentSum;
		InputValDigestSummation *paymentSum;
		InputValDigestSummation *originationSum;
		
}

-(id)initWithLoan:(LoanInput*)theLoan andSimParams:(SimParams*)theParams;

-(bool)loanOriginatesAfterSimStart;

@property(nonatomic,retain) LoanInput *loan;
@property(nonatomic,retain) PeriodicInterestBearingWorkingBalance *loanBalance;
@property(nonatomic,retain) VariableRateCalculator *extraPmtGrowthCalc;
@property(nonatomic,retain) SimParams *simParams;

@property(nonatomic,retain) InputValDigestSummation *downPaymentSum;
@property(nonatomic,retain) InputValDigestSummation *paymentSum;
@property(nonatomic,retain) InputValDigestSummation *originationSum;

-(double)downPaymentAmount;
-(NSDate*)loanOrigDate;
-(double)loanTermMonths;
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

- (double)extraPmtAmountAsOfDate:(NSDate*)pmtDate;

@end
