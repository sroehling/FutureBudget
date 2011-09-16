//
//  LoanPmtDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InterestBearingWorkingBalance;

@interface LoanPmtDigestEntry : NSObject {
    @private
		InterestBearingWorkingBalance *loanBalance;
		double paymentAmt;
}

@property(nonatomic,retain) InterestBearingWorkingBalance *loanBalance;
@property double paymentAmt;

-(id)initWithBalance:(InterestBearingWorkingBalance*)theLoanBal andPayment:(double)thePayment;

@end
