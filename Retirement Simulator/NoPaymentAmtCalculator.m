//
//  NoPaymentAmtCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/22/13.
//
//

#import "NoPaymentAmtCalculator.h"

@implementation NoPaymentAmtCalculator

-(double)paymentAmtForLoanInfo:(LoanSimInfo*)loanInfo andPmtDate:(NSDate*)paymentDate
{
	return 0.0;
}

-(BOOL)paymentIsSubsized
{
	return FALSE;
}


@end
