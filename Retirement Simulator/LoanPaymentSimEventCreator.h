//
//  LoanPaymentSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"

#import "ValueAsOfCalculator.h"

@class EventRepeater;
@class VariableRateCalculator;
@class CashWorkingBalance;
@class LoanInput;

@interface LoanPaymentSimEventCreator : NSObject <SimEventCreator> {
    @private
		CashWorkingBalance *loanWorkingBalance;
        EventRepeater *eventRepeater;
		VariableRateCalculator *interestRateCalc;
		LoanInput *loan;
		
		id<ValueAsOfCalculator> variableInterestRate;
		
		double loanOrigAmount;
		double unpaidLoanPrincipal;
		double monthlyPayment;
		NSDate *paymentInterestStartDate;
		
}

@property(nonatomic,retain) EventRepeater *eventRepeater;
@property(nonatomic,retain) VariableRateCalculator *interestRateCalc;
@property(nonatomic,retain) CashWorkingBalance *loanWorkingBalance;
@property(nonatomic,retain) LoanInput *loan;

@property(nonatomic,retain) id<ValueAsOfCalculator> variableInterestRate;

@property(nonatomic,retain) NSDate *paymentInterestStartDate;

- (id)initWithLoanWorkingBalance:(CashWorkingBalance*)theWorkingBalance
	andLoan:(LoanInput*)theLoan;

@end
