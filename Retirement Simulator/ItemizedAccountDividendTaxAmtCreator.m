//
//  ItemizedAccountDividendTaxAmtCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/2/13.
//
//

#import "ItemizedAccountDividendTaxAmtCreator.h"
#import "AccountDividendItemizedTaxAmt.h"
#import "InputCreationHelper.h"
#import "SharedAppValues.h"
#import "FormContext.h"
#import "DataModelController.h"

@implementation ItemizedAccountDividendTaxAmtCreator

- (ItemizedTaxAmt*)createItemizedTaxAmt
{
	AccountDividendItemizedTaxAmt *itemizedTaxAmt =
		[self.formContext.dataModelController insertObject:ACCOUNT_DIVIDEND_ITEMIZED_TAX_AMT_ENTITY_NAME];

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
