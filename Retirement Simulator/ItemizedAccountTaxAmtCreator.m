//
//  ItemizedSavingsTaxAmtCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedAccountTaxAmtCreator.h"
#import "DataModelController.h"
#import "AccountInterestItemizedTaxAmt.h"
#import "InputCreationHelper.h"


@implementation ItemizedAccountTaxAmtCreator

@synthesize account;

-(id)initWithAcct:(Account*)theAcct
{
	self = [super init];
	if(self)
	{
		assert(theAcct != nil);
		self.account = theAcct;
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
	assert(account != nil);
	AccountInterestItemizedTaxAmt *itemizedTaxAmt = [[DataModelController theDataModelController] 
		insertObject:ACCOUNT_INTEREST_ITEMIZED_TAX_AMT_ENTITY_NAME];
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] initForDatabaseInputs] autorelease];
	itemizedTaxAmt.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedTaxAmt.account  = self.account;
	return itemizedTaxAmt;
}


-(void)dealloc
{
	[super dealloc];
	[account release];
}

@end
