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
        // Contributions can happen into an account from either regular contributions or from transfers into
        // the account. Not consideriong transfers into the account, the boolean value of
        // self.account.contribEnabled would be used. However, since account transfers can
        // be considered, the result is always true if the account is enabled.
        return TRUE;
	}
	else
	{
		return FALSE;
	}
}

@end
