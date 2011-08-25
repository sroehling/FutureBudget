//
//  ExpenseInput.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ExpenseInput.h"
#import "InputVisitor.h"
#import "LocalizationHelper.h"

NSString * const EXPENSE_INPUT_ENTITY_NAME = @"ExpenseInput";
NSString * const EXPENSE_INPUT_TAX_DEDUCTIBLE_KEY = @"taxDeductible";

@implementation ExpenseInput

@dynamic taxDeductible;

-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
    [inputVisitor visitExpense:self];
}

- (NSString*)inlineInputType
{
	return LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_EXPENSE_INLINE");
}

-(NSString*)inputTypeTitle
{
	return LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_EXPENSE_TITLE");
}

@end
