//
//  LoanPmtAmtCalculator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/21/13.
//
//

#import <Foundation/Foundation.h>

@class LoanSimInfo;

@protocol LoanPmtAmtCalculator <NSObject>

-(double)paymentAmtForLoanInfo:(LoanSimInfo*)loanInfo andPmtDate:(NSDate*)paymentDate;
-(BOOL)paymentIsSubsized;

@end
