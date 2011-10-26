//
//  ExpenseSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CashFlowSimEventCreator.h"

@class ExpenseSimInfo;

@interface ExpenseSimEventCreator : CashFlowSimEventCreator {
    @private
		ExpenseSimInfo *expenseInfo;
}

- (id)initWithExpenseInfo:(ExpenseSimInfo*)theExpenseInfo;

@property(nonatomic,retain) ExpenseSimInfo *expenseInfo;

@end
