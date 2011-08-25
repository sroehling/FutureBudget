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
extern NSString * const EXPENSE_INPUT_TAX_DEDUCTIBLE_KEY;

@class EventRepeatFrequency;

@interface ExpenseInput : CashFlowInput {
@private
}
@property (nonatomic, retain) NSNumber * taxDeductible;

@end
