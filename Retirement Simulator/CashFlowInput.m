//
//  CashFlowInput.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CashFlowInput.h"
#import "EventRepeatFrequency.h"
#import "InputVisitor.h"
#import "VariableValue.h"


@implementation CashFlowInput

@dynamic startDate;
@dynamic endDate;
@dynamic amount;
@dynamic eventRepeatFrequency;
@dynamic cashFlowEnabled;
@dynamic amountGrowthRate;


-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
    [inputVisitor visitCashFlow:self];
}



@end
