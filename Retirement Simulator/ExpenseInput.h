//
//  ExpenseInput.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CashFlowInput.h"

extern NSString * const EXPENSE_INPUT_ENTITY_NAME;

@class EventRepeatFrequency;

@interface ExpenseInput : CashFlowInput {
@private
}

// Inverse Relationship
@property (nonatomic, retain) NSSet* expenseItemizedTaxAmts;
@property (nonatomic, retain) NSSet* accountLimitedWithdrawals;


@end
