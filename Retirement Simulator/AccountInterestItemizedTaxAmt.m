//
//  SavingsInterestItemizedTaxAmt.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountInterestItemizedTaxAmt.h"
#import "Account.h"
#import "ItemizedTaxAmtVisitor.h"

NSString * const ACCOUNT_INTEREST_ITEMIZED_TAX_AMT_ENTITY_NAME = @"AccountInterestItemizedTaxAmt";

@implementation AccountInterestItemizedTaxAmt
@dynamic account;


-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor
{
	assert(visitor != nil);
	[visitor visitAccountInterestItemizedTaxAmt:self];
}


@end
