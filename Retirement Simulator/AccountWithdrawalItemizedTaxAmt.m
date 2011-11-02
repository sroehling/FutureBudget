//
//  AccountWithdrawalItemizedTaxAmt.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountWithdrawalItemizedTaxAmt.h"
#import "Account.h"
#import "ItemizedTaxAmtVisitor.h"

NSString * const ACCOUNT_WITHDRAWAL_ITEMIZED_TAX_AMT_ENTITY_NAME = 
	@"AccountWithdrawalItemizedTaxAmt";

@implementation AccountWithdrawalItemizedTaxAmt
@dynamic account;

-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor
{
	assert(visitor != nil);
	[visitor visitAccountWithdrawalItemizedTaxAmt:self];
}


@end
