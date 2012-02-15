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
#import "FormContext.h"
#import "SharedAppValues.h"

@implementation ItemizedAccountContribTaxAmtCreator

- (ItemizedTaxAmt*)createItemizedTaxAmt
{
	AccountContribItemizedTaxAmt *itemizedTaxAmt = [self.formContext.dataModelController insertObject:ACCOUNT_CONTRIB_ITEMIZED_TAX_AMT_ENTITY_NAME];
	SharedAppValues *sharedAppVals = [SharedAppValues getUsingDataModelController:self.formContext.dataModelController];
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] 
		initWithDataModelInterface:self.formContext.dataModelController 
			andSharedAppVals:sharedAppVals] autorelease];
	itemizedTaxAmt.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedTaxAmt.account  = self.account;
	return itemizedTaxAmt;

}

@end
