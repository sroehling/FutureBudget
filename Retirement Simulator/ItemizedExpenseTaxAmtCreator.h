//
//  ExpenseItemizedTaxAmtCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemizedTaxAmtCreator.h"

@class ExpenseInput;

@interface ItemizedExpenseTaxAmtCreator : NSObject <ItemizedTaxAmtCreator> {
	@private
		ExpenseInput *expense;
}
@property(nonatomic,retain) ExpenseInput *expense;

- (id)initWithExpense:(ExpenseInput*)theExpense;

@end
