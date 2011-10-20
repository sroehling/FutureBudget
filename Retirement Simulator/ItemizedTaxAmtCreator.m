//
//  ItemizedTaxAmtCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxAmtCreator.h"
#import "InputCreationHelper.h"
#import "DataModelController.h"
#import "IncomeItemizedTaxAmt.h"

@implementation ItemizedIncomeTaxAmtCreator

@synthesize income;

- (id)initWithIncome:(IncomeInput*)theIncome
{
	self = [super init];
	if(self)
	{
		assert(theIncome != nil);
		self.income = theIncome;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

- (ItemizedTaxAmt*)createItemizedTaxAmt
{
	assert(income != nil);
	IncomeItemizedTaxAmt *itemizedTaxAmt = [[DataModelController theDataModelController] insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] initWithDataModelInterface:[DataModelController theDataModelController]] autorelease];
	itemizedTaxAmt.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedTaxAmt.income  = self.income;
	return itemizedTaxAmt;

}

-(void)dealloc
{
	[super dealloc];
	[income release];
}

@end