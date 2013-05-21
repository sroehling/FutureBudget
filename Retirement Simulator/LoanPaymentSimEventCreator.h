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
@class InterestBearingWorkingBalance;
@class LoanSimInfo;

@interface LoanPaymentSimEventCreator : NSObject <SimEventCreator> {
    @private
        EventRepeater *eventRepeater;
		LoanSimInfo *loanInfo;
		
		BOOL hasDeferredPayments;
		
}

@property(nonatomic,retain) EventRepeater *eventRepeater;
@property(nonatomic,retain) LoanSimInfo *loanInfo;

- (id)initWithLoanInfo:(LoanSimInfo*)theLoanInfo;

@end
