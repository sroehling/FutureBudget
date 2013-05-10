//
//  AccountCapitalLossItemizedTaxAmt.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/10/13.
//
//

#import "AccountCapitalLossItemizedTaxAmt.h"
#import "Account.h"
#import "ItemizedTaxAmtVisitor.h"

NSString * const ACCOUNT_CAPITAL_LOSS_ITEMIZED_TAX_AMT_ENTITY_NAME = @"AccountCapitalLossItemizedTaxAmt";

@implementation AccountCapitalLossItemizedTaxAmt

@dynamic account;

-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor
{
	assert(visitor != nil);
	[visitor visitAccountCapitalLossItemizedTaxAmt:self];
}

-(BOOL)itemIsEnabledForScenario:(Scenario*)theScenario
{
	assert(theScenario != nil);
	assert(self.account != nil);
	if([self.isEnabled boolValue])
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}


@end
