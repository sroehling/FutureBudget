//
//  ExpenseSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CashFlowSimEventCreator.h"

@class ExpenseInput;

@interface ExpenseSimEventCreator : CashFlowSimEventCreator {
    @private
		ExpenseInput *expense;
}

- (id)initWithExpense:(ExpenseInput*)theExpense;

@property(nonatomic,retain) ExpenseInput *expense;

@end
