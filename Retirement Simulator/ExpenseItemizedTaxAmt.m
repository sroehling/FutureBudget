//
//  ExpenseItemizedTaxAmt.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ExpenseItemizedTaxAmt.h"
#import "ExpenseInput.h"
#import "ItemizedTaxAmtVisitor.h"
#import "SimInputHelper.h"

NSString * const EXPENSE_ITEMIZED_TAX_AMT_ENTITY_NAME = @"ExpenseItemizedTaxAmt";

@implementation ExpenseItemizedTaxAmt
@dynamic expense;

-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor
{
	assert(visitor != nil);
	[visitor visitExpenseItemizedTaxAmt:self];
}

-(BOOL)itemIsEnabledForScenario:(Scenario*)theScenario
{
	assert(theScenario != nil);
	assert(self.expense != nil);
	if([self.isEnabled boolValue])
	{
		return [SimInputHelper multiScenBoolVal:self.expense.cashFlowEnabled
				andScenario:theScenario];
	}
	else
	{
		return FALSE;
	}
}

@end
