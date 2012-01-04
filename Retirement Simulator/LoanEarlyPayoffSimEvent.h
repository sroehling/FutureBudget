//
//  LoanEarlyPayoffSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"

@class LoanSimInfo;

@interface LoanEarlyPayoffSimEvent : SimEvent {
    @private
		LoanSimInfo *loanInfo;
}

@property(nonatomic,retain) LoanSimInfo *loanInfo;

- (id)initWithLoanInfo:(LoanSimInfo*)theLoanInfo 
	andEventCreator:(id<SimEventCreator>)theEventCreator 
	andEventDate:(NSDate *)theEventDate;

@end
