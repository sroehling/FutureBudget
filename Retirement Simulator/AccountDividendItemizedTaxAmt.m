//
//  AccountDividendItemizedTaxAmt.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/2/13.
//
//

#import "AccountDividendItemizedTaxAmt.h"
#import "Account.h"
#import "ItemizedTaxAmtVisitor.h"
#import "SimInputHelper.h"

NSString * const ACCOUNT_DIVIDEND_ITEMIZED_TAX_AMT_ENTITY_NAME = @"AccountDividendItemizedTaxAmt";

@implementation AccountDividendItemizedTaxAmt

@dynamic account;

-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor
{
	assert(visitor != nil);
	[visitor visitAccountDividendItemizedTaxAmt:self];
}

-(BOOL)itemIsEnabledForScenario:(Scenario*)theScenario
{
	assert(theScenario != nil);
	assert(self.account != nil);
	if([self.isEnabled boolValue])
	{
		return [SimInputHelper multiScenBoolVal:self.account.dividendEnabled
				andScenario:theScenario];
	}
	else
	{
		return FALSE;
	}
}


@end
