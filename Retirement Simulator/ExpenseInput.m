//
//  ExpenseInput.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ExpenseInput.h"
#import "InputVisitor.h"

@implementation ExpenseInput
@dynamic amount;
@dynamic transactionDate;
@dynamic repeatFrequency;


-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [inputVisitor visitExpense:self];
}

@end
