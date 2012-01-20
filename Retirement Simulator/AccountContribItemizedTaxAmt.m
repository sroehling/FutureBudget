//
//  AccountContribItemizedTaxAmt.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountContribItemizedTaxAmt.h"
#import "Account.h"
#import "ItemizedTaxAmtVisitor.h"
#import "SimInputHelper.h"

NSString * const ACCOUNT_CONTRIB_ITEMIZED_TAX_AMT_ENTITY_NAME = @"AccountContribItemizedTaxAmt";

@implementation AccountContribItemizedTaxAmt
@dynamic account;

-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor
{
	assert(visitor != nil);
	[visitor visitAccountContribItemizedTaxAmt:self];
}

-(BOOL)itemIsEnabledForScenario:(Scenario*)theScenario
{
	assert(theScenario != nil);
	assert(self.account != nil);
	if([self.isEnabled boolValue])
	{
		return [SimInputHelper multiScenBoolVal:self.account.contribEnabled
				andScenario:theScenario];
	}
	else
	{
		return FALSE;
	}
}

@end
