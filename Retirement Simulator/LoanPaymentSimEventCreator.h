//
//  LoanPaymentSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"

#import "ValueAsOfCalculator.h"

@class EventRepeater;
@class VariableRateCalculator;
@class InterestBearingWorkingBalance;
@class LoanInput;

@interface LoanPaymentSimEventCreator : NSObject <SimEventCreator> {
    @private
		InterestBearingWorkingBalance *loanBalance;
        EventRepeater *eventRepeater;
		LoanInput *loan;
		
		double monthlyPayment;
		
}

@property(nonatomic,retain) EventRepeater *eventRepeater;
@property(nonatomic,retain) InterestBearingWorkingBalance *loanBalance;
@property(nonatomic,retain) LoanInput *loan;

- (id)initWithLoan:(LoanInput*)theLoan;

@end
