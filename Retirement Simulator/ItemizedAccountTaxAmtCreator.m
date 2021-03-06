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
#import "FormContext.h"
#import "SharedAppValues.h"

@implementation ItemizedAccountTaxAmtCreator

- (ItemizedTaxAmt*)createItemizedTaxAmt
{
	AccountInterestItemizedTaxAmt *itemizedTaxAmt = [self.formContext.dataModelController 
		insertObject:ACCOUNT_INTEREST_ITEMIZED_TAX_AMT_ENTITY_NAME];

	SharedAppValues *sharedAppVals = [SharedAppValues getUsingDataModelController:self.formContext.dataModelController];
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] initWithDataModelController:self.formContext.dataModelController 
			andSharedAppVals:sharedAppVals] autorelease];
	itemizedTaxAmt.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedTaxAmt.account  = self.account;
	return itemizedTaxAmt;
}

@end
