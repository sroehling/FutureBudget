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
		bool isTaxable;
    
}

@property double expenseAmount;
@property bool isTaxable;

-(id)initWithEventCreator:(id<SimEventCreator>)eventCreator 
	andEventDate:(NSDate *)theEventDate andAmount:(double)theAmount 
	andIsTaxable:(bool)expenseIsTaxable;


@end
