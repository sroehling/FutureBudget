//
//  LoanInterestItemizedTaxAmt.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LoanInterestItemizedTaxAmt.h"
#import "LoanInput.h"
#import "ItemizedTaxAmtVisitor.h"

NSString * const LOAN_INTEREST_ITEMIZED_TAX_AMT_ENTITY_NAME = @"LoanInterestItemizedTaxAmt";

@implementation LoanInterestItemizedTaxAmt
@dynamic loan;

-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor
{
	assert(visitor != nil);
	[visitor visitLoanInterestItemizedTaxAmt:self];
}


@end
