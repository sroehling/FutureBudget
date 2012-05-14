//
//  DownPaymentSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"

@class LoanInput;
@class LoanSimInfo;

@interface LoanOrigSimEventCreator : NSObject <SimEventCreator> {
    @private
		LoanSimInfo *loanInfo;
		bool origEventCreated;

}

@property(nonatomic,retain) LoanSimInfo *loanInfo;

- (id)initWithLoanInfo:(LoanSimInfo*)theLoanInfo;

@end
