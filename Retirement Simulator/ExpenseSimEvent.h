//
//  ExpenseSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimEvent.h"

@class ExpenseInput;

@interface ExpenseSimEvent : SimEvent {
	@private
		double expenseAmount;
		ExpenseInput *expense;
    
}

@property(nonatomic,retain) ExpenseInput *expense;
@property double expenseAmount;

@end
