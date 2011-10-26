//
//  CashFlowDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InputValDigestSummation;

@interface CashFlowDigestEntry : NSObject {
    @private
		double amount;
		InputValDigestSummation *cashFlowSummation;
}

@property double amount;
@property(nonatomic,retain) InputValDigestSummation *cashFlowSummation;

-(id)initWithAmount:(double)theAmount 
	andCashFlowSummation:(InputValDigestSummation*)theSummation;

@end
