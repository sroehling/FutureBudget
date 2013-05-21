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

@interface LoanSimInfo : NSObject {
    @private
		LoanInput *loan;
		SimParams *simParams;
		InterestBearingWorkingBalance *loanBalance;
		VariableRateCalculator *extraPmtGrowthCalc;

}

-(id)initWithLoan:(LoanInput*)theLoan andSimParams:(SimParams*)theParams;

-(bool)loanOriginatesAfterSimStart;

@property(nonatomic,retain) LoanInput *loan;
@property(nonatomic,retain) InterestBearingWorkingBalance *loanBalance;
@property(nonatomic,retain) VariableRateCalculator *extraPmtGrowthCalc;
@property(nonatomic,retain) SimParams *simParams;


-(double)downPaymentAmount;
-(NSDate*)loanOrigDate;
- (double)startingBalanceAfterDownPayment; // Starting balance on the date of loan origination

-(NSDate*)earlyPayoffDate;
-(bool)earlyPayoffAfterOrigination;
- (bool)earlyPayoffAfterSimStart;
-(BOOL)deferredPaymentDateEnabled;
-(BOOL)beforeDeferredPaymentDate:(NSDate*)pmtDate;

- (double)loanOrigAmount;

- (EventRepeater*)createLoanPmtRepeater;
- (double)monthlyPayment;
- (double)extraPmtAmountAsOfDate:(NSDate*)pmtDate;

-(double)simulatedStartingBalanceForPastLoanOrigination;

@end
