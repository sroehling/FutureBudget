//
//  ExtraPaymentSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"

@class EventRepeater;
@class LoanSimInfo;

@interface ExtraPaymentSimEventCreator : NSObject <SimEventCreator> {
    @private
        EventRepeater *eventRepeater;
		LoanSimInfo *loanInfo;
}

@property(nonatomic,retain) EventRepeater *eventRepeater;
@property(nonatomic,retain) LoanSimInfo *loanInfo;

- (id)initWithLoanInfo:(LoanSimInfo*)theLoanInfo;

@end
