//
//  LoanSimInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoanInput;
@class InterestBearingWorkingBalance;
@class EventRepeater;

@interface LoanSimInfo : NSObject {
    @private
		LoanInput *loan;
		InterestBearingWorkingBalance *loanBalance;
}

-(id)initWithLoan:(LoanInput*)theLoan;

-(bool)loanOriginatesAfterSimStart;

@property(nonatomic,retain) LoanInput *loan;
@property(nonatomic,retain) InterestBearingWorkingBalance *loanBalance;

-(double)downPaymentAmount;
-(NSDate*)loanOrigDate;
- (double)loanOrigAmount;
-(bool)interestIsTaxable;

- (EventRepeater*)createLoanPmtRepeater;
- (double)monthlyPayment;

@end
