//
//  ItemizedSavingsTaxAmtCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedSavingsTaxAmtCreator.h"
#import "DataModelController.h"
#import "SavingsInterestItemizedTaxAmt.h"
#import "InputCreationHelper.h"


@implementation ItemizedSavingsTaxAmtCreator

@synthesize savingsAcct;

-(id)initWithSavingsAcct:(SavingsAccount*)theSavingsAcct
{
	self = [super init];
	if(self)
	{
		assert(theSavingsAcct != nil);
		self.savingsAcct = theSavingsAcct;
	}
	return self;
}

-(id)init
{
	assert(0); // must init with savings account
	return nil;
}

- (ItemizedTaxAmt*)createItemizedTaxAmt
{
	assert(savingsAcct != nil);
	SavingsInterestItemizedTaxAmt *itemizedTaxAmt = [[DataModelController theDataModelController] 
		insertObject:SAVINGS_INTEREST_ITEMIZED_TAX_AMT_ENTITY_NAME];
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] initForDatabaseInputs] autorelease];
	itemizedTaxAmt.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedTaxAmt.savingsAcct  = self.savingsAcct;
	return itemizedTaxAmt;
}


-(void)dealloc
{
	[super dealloc];
	[savingsAcct release];
}

@end
