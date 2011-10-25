//
//  ExpenseSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimEvent.h"


@interface ExpenseSimEvent : SimEvent {
	@private
		double expenseAmount;
    
}

@property double expenseAmount;

-(id)initWithEventCreator:(id<SimEventCreator>)eventCreator 
	andEventDate:(NSDate *)theEventDate andAmount:(double)theAmount;


@end
