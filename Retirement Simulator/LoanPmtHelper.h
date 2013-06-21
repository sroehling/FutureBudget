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

+(double)annualizedPeriodicLoanInterestRate:(double)annualRateEnteredByUser;
+(double)monthlyPeriodicLoanInterestRate:(double)annualRateEnteredByUser;


@end
