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


@implementation CashFlowInput
@dynamic amount;
@dynamic repeatFrequency;
@dynamic amountGrowthRate;
@dynamic startDate;
@dynamic fixedStartDate;
@dynamic endDate;
@dynamic fixedEndDate;
@dynamic defaultFixedGrowthRate;

-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
    [inputVisitor visitCashFlow:self];
}


@end
