//
//  LoanPmtHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/4/13.
//
//

#import <Foundation/Foundation.h>

@class LoanSimInfo;
@class DigestEntryProcessingParams;

@interface LoanPmtHelper : NSObject

+(void)decrementLoanPayment:(double)pmtAmt forLoanInfo:(LoanSimInfo*)loanInfo
	andProcessingParams:(DigestEntryProcessingParams*)processingParams;

+(void)decrementLoanPayment:(double)pmtAmt forLoanInfo:(LoanSimInfo*)loanInfo
	andProcessingParams:(DigestEntryProcessingParams*)processingParams andSubsidizedPmt:(BOOL)paymentIsSubsidized;

@end
