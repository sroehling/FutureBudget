//
//  RegularPaymentAmtCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/21/13.
//
//

#import "RegularPaymentAmtCalculator.h"
#import "LoanSimInfo.h"

@implementation RegularPaymentAmtCalculator

-(double)paymentAmtForLoanInfo:(LoanSimInfo*)loanInfo andPmtDate:(NSDate*)paymentDate
{
	// TODO - This will need to be expanded to work with deferred dates. 
	return [loanInfo monthlyPayment];
}

-(BOOL)paymentIsSubsized
{
	return FALSE;
}


@end
