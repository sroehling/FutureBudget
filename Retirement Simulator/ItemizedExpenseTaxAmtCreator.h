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
		NSString *label;
}

@property(nonatomic,retain) ExpenseInput *expense;
@property(nonatomic,retain) NSString *label;

- (id)initWithExpense:(ExpenseInput*)theExpense andLabel:(NSString*)theLabel;

@end
