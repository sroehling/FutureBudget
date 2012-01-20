//
//  IncomeItemizedTaxAmt.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IncomeItemizedTaxAmt.h"
#import "IncomeInput.h"
#import "ItemizedTaxAmtVisitor.h"
#import "SimInputHelper.h"

NSString * const INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME = @"IncomeItemizedTaxAmt";

@implementation IncomeItemizedTaxAmt
@dynamic income;

-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor
{
	assert(visitor != nil);
	[visitor visitIncomeItemizedTaxAmt:self];
}


-(BOOL)itemIsEnabledForScenario:(Scenario*)theScenario
{
	assert(theScenario != nil);
	assert(self.income != nil);
	if([self.isEnabled boolValue])
	{
		return [SimInputHelper multiScenBoolVal:self.income.cashFlowEnabled
				andScenario:theScenario];
	}
	else
	{
		return FALSE;
	}
}

@end
