//
//  ExtraLoanPmtAmtCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/21/13.
//
//

#import "ExtraLoanPmtProcessor.h"
#import "LoanSimInfo.h"
#import "LoanPmtHelper.h"
#import "DigestEntryProcessingParams.h"

@implementation ExtraLoanPmtProcessor

-(void)processPmtForLoanInfo:(LoanSimInfo*)loanInfo andProcessingParams:(DigestEntryProcessingParams*)processingParams
{

	// TBD - Need to ensure the balance has been advanced to the current date.

	double pmtAmount = [loanInfo extraPmtAmountAsOfDate:processingParams.currentDate];

	[LoanPmtHelper decrementLoanPayment:pmtAmount forLoanInfo:loanInfo andProcessingParams:processingParams];
}


@end
