//
//  InterestOnlyPaymentAmtCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/21/13.
//
//

#import "InterestOnlyPaymentAmtCalculator.h"
#import "LoanSimInfo.h"
#import "InterestBearingWorkingBalance.h"

@implementation InterestOnlyPaymentAmtCalculator

-(double)paymentAmtForLoanInfo:(LoanSimInfo*)loanInfo andPmtDate:(NSDate*)paymentDate
{
	// Advance the balance to accrue any interest.
	[loanInfo.loanBalance advanceCurrentBalanceToDate:paymentDate];
	
	double currBalance = [loanInfo.loanBalance currentBalanceForDate:paymentDate];
	
	double startingBal = [loanInfo startingBalanceAfterDownPayment];
	
	
	if(currBalance > startingBal)
	{
		double unpaidInterest = currBalance - startingBal;
		return unpaidInterest;
	}
	else
	{
		return 0.0;
	}
	
}


@end
