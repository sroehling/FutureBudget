//
//  LoanDownPmtSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"

@class LoanSimInfo;

@interface LoanOrigSimEvent : SimEvent {
    @private
		LoanSimInfo *loanInfo;
}

@property(nonatomic,retain) LoanSimInfo *loanInfo;

-(id)initWithEventCreator:(id<SimEventCreator>)eventCreator 
	andEventDate:(NSDate *)theEventDate andLoanInfo:(LoanSimInfo*)theLoanInfo;
	

@end
