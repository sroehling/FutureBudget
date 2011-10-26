//
//  ExpenseSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimEvent.h"
#import "ExpenseSimInfo.h"

@interface ExpenseSimEvent : SimEvent {
	@private
		double expenseAmount;
		ExpenseSimInfo *expenseInfo;
}

@property double expenseAmount;
@property(nonatomic,retain) ExpenseSimInfo *expenseInfo;

-(id)initWithEventCreator:(id<SimEventCreator>)eventCreator 
	andEventDate:(NSDate *)theEventDate andAmount:(double)theAmount
	andExpenseInfo:(ExpenseSimInfo*)theExpenseInfo;

@end
