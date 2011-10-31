//
//  ExpenseItemizedTaxAmt.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemizedTaxAmt.h"

extern NSString * const EXPENSE_ITEMIZED_TAX_AMT_ENTITY_NAME;

@class ExpenseInput;

@interface ExpenseItemizedTaxAmt : ItemizedTaxAmt {
@private
}
@property (nonatomic, retain) ExpenseInput * expense;

@end
