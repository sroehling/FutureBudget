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
#import "SimInputHelper.h"

NSString * const LOAN_INTEREST_ITEMIZED_TAX_AMT_ENTITY_NAME = @"LoanInterestItemizedTaxAmt";

@implementation LoanInterestItemizedTaxAmt
@dynamic loan;

-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor
{
	assert(visitor != nil);
	[visitor visitLoanInterestItemizedTaxAmt:self];
}

-(BOOL)itemIsEnabledForScenario:(Scenario*)theScenario
{
	assert(theScenario != nil);
	assert(self.loan != nil);
	if([self.isEnabled boolValue])
	{
		return [SimInputHelper multiScenBoolVal:self.loan.loanEnabled
				andScenario:theScenario];
	}
	else
	{
		return FALSE;
	}
}

@end
