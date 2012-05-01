//
//  TaxesPaidItemizedTaxAmt.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TaxesPaidItemizedTaxAmt.h"
#import "TaxInput.h"
#import "SimInputHelper.h"
#import "ItemizedTaxAmtVisitor.h"

NSString * const TAXES_PAID_ITEMIZED_TAX_AMT_ENTITY_NAME = @"TaxesPaidItemizedTaxAmt";

@implementation TaxesPaidItemizedTaxAmt

@dynamic tax;


-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor
{
	assert(visitor != nil);
	[visitor visitTaxesPaidItemizedTaxAmt:self];
}

-(BOOL)itemIsEnabledForScenario:(Scenario*)theScenario
{
	assert(theScenario != nil);
	assert(self.tax != nil);
	if([self.isEnabled boolValue])
	{
		return [SimInputHelper multiScenBoolVal:self.tax.taxEnabled
				andScenario:theScenario];
	}
	else
	{
		return FALSE;
	}
}


@end
