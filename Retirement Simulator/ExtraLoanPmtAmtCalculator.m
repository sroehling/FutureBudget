//
//  ExtraLoanPmtAmtCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/21/13.
//
//

#import "ExtraLoanPmtAmtCalculator.h"
#import "LoanSimInfo.h"

@implementation ExtraLoanPmtAmtCalculator

-(double)paymentAmtForLoanInfo:(LoanSimInfo*)loanInfo andPmtDate:(NSDate*)paymentDate
{
	return [loanInfo extraPmtAmountAsOfDate:paymentDate];
}

@end
