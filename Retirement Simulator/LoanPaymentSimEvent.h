//
//  LoanPaymentSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"
#import "LoanPmtAmtCalculator.h"

@class LoanSimInfo;

@interface LoanPaymentSimEvent : SimEvent {
    @private
		LoanSimInfo *loanInfo;
		id<LoanPmtAmtCalculator> pmtCalculator;

}

@property(nonatomic,retain) LoanSimInfo *loanInfo;
@property(nonatomic,retain) id<LoanPmtAmtCalculator> pmtCalculator;

@end
