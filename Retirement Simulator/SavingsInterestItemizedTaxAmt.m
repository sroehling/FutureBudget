//
//  SavingsInterestItemizedTaxAmt.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SavingsInterestItemizedTaxAmt.h"
#import "SavingsAccount.h"
#import "ItemizedTaxAmtVisitor.h"

NSString * const SAVINGS_INTEREST_ITEMIZED_TAX_AMT_ENTITY_NAME = @"SavingsInterestItemizedTaxAmt";

@implementation SavingsInterestItemizedTaxAmt
@dynamic savingsAcct;


-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor
{
	assert(visitor != nil);
	[visitor visitSavingsInterestItemizedTaxAmt:self];
}


@end
