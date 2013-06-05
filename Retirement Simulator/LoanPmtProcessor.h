//
//  LoanPmtAmtCalculator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/21/13.
//
//

#import <Foundation/Foundation.h>

@class LoanSimInfo;
@class DigestEntryProcessingParams;

@protocol LoanPmtProcessor <NSObject>

-(void)processPmtForLoanInfo:(LoanSimInfo*)loanInfo andProcessingParams:(DigestEntryProcessingParams*)processingParams;

@end
