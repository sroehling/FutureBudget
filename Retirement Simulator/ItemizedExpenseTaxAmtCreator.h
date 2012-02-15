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
@class FormContext;

@interface ItemizedExpenseTaxAmtCreator : NSObject <ItemizedTaxAmtCreator> {
	@private
		FormContext *formContext;
		ExpenseInput *expense;
		NSString *label;
}

@property(nonatomic,retain) FormContext *formContext;
@property(nonatomic,retain) ExpenseInput *expense;
@property(nonatomic,retain) NSString *label;

- (id)initWithFormContext:(FormContext*)theFormContext 
		andExpense:(ExpenseInput*)theExpense andLabel:(NSString*)theLabel;

@end
