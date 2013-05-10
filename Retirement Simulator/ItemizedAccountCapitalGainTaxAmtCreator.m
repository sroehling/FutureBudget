//
//  ItemizedAccountCapitalGainTaxAmtCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/10/13.
//
//

#import "ItemizedAccountCapitalGainTaxAmtCreator.h"

#import "AccountCapitalGainItemizedTaxAmt.h"
#import "InputCreationHelper.h"
#import "SharedAppValues.h"
#import "FormContext.h"
#import "DataModelController.h"


@implementation ItemizedAccountCapitalGainTaxAmtCreator


- (ItemizedTaxAmt*)createItemizedTaxAmt
{
	AccountCapitalGainItemizedTaxAmt *itemizedTaxAmt =
		[self.formContext.dataModelController insertObject:ACCOUNT_CAPITAL_GAIN_ITEMIZED_TAX_AMT_ENTITY_NAME];

	SharedAppValues *sharedAppVals = [SharedAppValues
		getUsingDataModelController:self.formContext.dataModelController];
		
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] 
		initWithDataModelController:self.formContext.dataModelController 
			andSharedAppVals:sharedAppVals] autorelease];
			
	itemizedTaxAmt.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedTaxAmt.account  = self.account;
	return itemizedTaxAmt;

}


@end
