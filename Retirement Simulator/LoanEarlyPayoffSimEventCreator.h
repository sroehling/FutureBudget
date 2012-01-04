//
//  LoanEarlyPayoffSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"

@class LoanSimInfo;

@interface LoanEarlyPayoffSimEventCreator : NSObject <SimEventCreator> {
    @private
		LoanSimInfo *loanInfo;
		bool eventCreated;
}

@property(nonatomic,retain) LoanSimInfo *loanInfo;

- (id)initWithLoanInfo:(LoanSimInfo*)theLoanInfo;

@end
