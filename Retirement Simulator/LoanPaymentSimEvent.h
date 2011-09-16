//
//  LoanPaymentSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"

@class InterestBearingWorkingBalance;

@interface LoanPaymentSimEvent : SimEvent {
    @private
		double paymentAmt;
		InterestBearingWorkingBalance *loanBalance;
}

@property double paymentAmt;
@property (nonatomic,retain) InterestBearingWorkingBalance *loanBalance;

@end
