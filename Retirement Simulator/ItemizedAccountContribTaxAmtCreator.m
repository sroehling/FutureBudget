//
//  ItemizedAccountContribTaxAmtCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedAccountContribTaxAmtCreator.h"
#import "Account.h"
#import "AccountContribItemizedTaxAmt.h"
#import "DataModelController.h"
#import "InputCreationHelper.h"

@implementation ItemizedAccountContribTaxAmtCreator

@synthesize account;

- (id)initWithAccount:(Account*)theAccount
{
	self = [super init];
	if(self)
	{
		assert(theAccount != nil);
		self.account = theAccount;
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
	assert(account != nil);
	AccountContribItemizedTaxAmt *itemizedTaxAmt = [[DataModelController theDataModelController] insertObject:ACCOUNT_CONTRIB_ITEMIZED_TAX_AMT_ENTITY_NAME];
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] 
		initForDatabaseInputs] autorelease];
	itemizedTaxAmt.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedTaxAmt.account  = self.account;
	return itemizedTaxAmt;

}

-(NSString*)itemLabel
{
	return self.account.name;
}

-(void)dealloc
{
	[super dealloc];
	[account release];
}



@end
