//
//  CashFlowDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InputValDigestSummation;
@class WorkingBalanceMgr;

@interface CashFlowDigestEntry : NSObject {
    @private
		double amount;
		InputValDigestSummation *cashFlowSummation;
}

@property double amount;
@property(nonatomic,retain) InputValDigestSummation *cashFlowSummation;

-(id)initWithAmount:(double)theAmount 
	andCashFlowSummation:(InputValDigestSummation*)theSummation;

-(void)processEntry:(WorkingBalanceMgr*)workingBalanceMgr
	andDate:(NSDate*)currentDate;

@end
