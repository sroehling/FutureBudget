//
//  LoanDownPmtSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"


@interface LoanDownPmtSimEvent : SimEvent {
    @private
		double downPmtAmt;
}

@property double downPmtAmt;

-(id)initWithEventCreator:(id<SimEventCreator>)eventCreator 
	andEventDate:(NSDate *)theEventDate andAmount:(double)theAmount;

@end
