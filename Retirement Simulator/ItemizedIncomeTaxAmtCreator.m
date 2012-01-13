//
//  ItemizedIncomeTaxAmtCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedIncomeTaxAmtCreator.h"
#import "DataModelController.h"
#import "InputCreationHelper.h"
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
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] 
		initForDatabaseInputs] autorelease];
	itemizedTaxAmt.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedTaxAmt.income  = self.income;
	return itemizedTaxAmt;

}

-(NSString*)itemLabel
{
	return self.income.name;
}


-(void)dealloc
{
	[super dealloc];
	[income release];
}


@end
