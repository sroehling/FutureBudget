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

-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
    [inputVisitor visitExpense:self];
}

@end
