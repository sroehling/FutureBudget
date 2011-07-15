//
//  IncomeInput.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IncomeInput.h"
#import "InputVisitor.h"
#import "LocalizationHelper.h"

 NSString * const INCOME_INPUT_ENTITY_NAME = @"IncomeInput";

@implementation IncomeInput


-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
    [inputVisitor visitIncome:self];
}

- (NSString*)inlineInputType
{
	return LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_INCOME_INLINE");
}

-(NSString*)inputTypeTitle
{
	return LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_INCOME_TITLE");
}


@end
