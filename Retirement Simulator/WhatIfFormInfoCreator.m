//
//  WhatIfFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WhatIfFormInfoCreator.h"
#import "FormInfo.h"
#import "FormPopulator.h"
#import "SectionInfo.h"
#import "LocalizationHelper.h"
#import "StaticNavFieldEditInfo.h"
#import "DataModelController.h"
#import "BoolFieldEditInfo.h"
#import "LoanInput.h"
#import "SharedAppValues.h"
#import "Account.h"
#import "ExpenseInput.h"
#import "IncomeInput.h"
#import "AssetInput.h"
#import "NumberHelper.h"
#import "DeferredWithdrawalFieldEditInfo.h"
#import "Scenario.h"
#import "ScenarioListFormInfoCreator.h"
#import "ManagedObjectFieldInfo.h"

#import "SelectableObjectTableViewControllerFactory.h"
#import "PositiveNumberValidator.h"
#import "InputFormPopulator.h"

@implementation WhatIfFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"WHAT_IF_NAV_CONTROLLER_BUTTON_TITLE");
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	
	SharedAppValues *theSharedAppValues = [SharedAppValues singleton];
	ManagedObjectFieldInfo *currentScenarioFieldInfo = 
		[[[ManagedObjectFieldInfo alloc] initWithManagedObject:theSharedAppValues andFieldKey:SHARED_APP_VALUES_CURRENT_INPUT_SCENARIO_KEY 
			andFieldLabel:@"dummy" andFieldPlaceholder:@"dummy"] autorelease];
	ScenarioListFormInfoCreator *scenarioFormInfoCreator = 
		[[[ScenarioListFormInfoCreator alloc] init] autorelease];
		
	SelectableObjectTableViewControllerFactory *scenarioListViewFactory = 
		[[[SelectableObjectTableViewControllerFactory alloc] initWithFormInfoCreator:scenarioFormInfoCreator andAssignedField:currentScenarioFieldInfo] autorelease];
			
	
	sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_SCENARIO_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"WHAT_IF_SCENARIO_SECTION_SUBTITLE");
	StaticNavFieldEditInfo *scenarioFieldEditInfo = 
		[[[StaticNavFieldEditInfo alloc] 
			initWithCaption:LOCALIZED_STR(@"WHAT_IF_SCENARIO_FORM_TITLE")
			andSubtitle:LOCALIZED_STR(@"WHAT_IF_SCENARIO_SUBTITLE") 
			andContentDescription:theSharedAppValues.currentInputScenario.scenarioName
			andSubViewFactory:scenarioListViewFactory] autorelease];
	[sectionInfo addFieldEditInfo:scenarioFieldEditInfo];		
			
					
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_INPUT_CHANGES_SECTION_TITLE");
	
	id<FormInfoCreator> whatIfFormInfoCreator = 
		[[[WhatIfInputsEnabledFormInfoCreator alloc] init] autorelease];
	StaticNavFieldEditInfo *whatIfFieldEditInfo = 
		[[[StaticNavFieldEditInfo alloc] 
			initWithCaption:LOCALIZED_STR(@"WHAT_IF_ENABLED_FORM_TITLE") 
			andSubtitle:LOCALIZED_STR(@"WHAT_IF_ENABLED_SUBTITLE") 
			andContentDescription:nil  
			andSubFormInfoCreator:whatIfFormInfoCreator] autorelease];
	[sectionInfo addFieldEditInfo:whatIfFieldEditInfo];
	
	
	whatIfFormInfoCreator = [[[WhatIfWithdrawalsFormInfoCreator alloc] init] autorelease];
	whatIfFieldEditInfo = [[[StaticNavFieldEditInfo alloc] 
			initWithCaption:LOCALIZED_STR(@"WHAT_IF_WITHDRAWALS_FORM_TITLE")  
			andSubtitle:LOCALIZED_STR(@"WHAT_IF_WITHDRAWALS_SUBTITLE") 
			andContentDescription:nil  
			andSubFormInfoCreator:whatIfFormInfoCreator] autorelease];
	[sectionInfo addFieldEditInfo:whatIfFieldEditInfo];

	whatIfFormInfoCreator = [[[WhatIfAmountFormInfoCreator alloc] init] autorelease];
	whatIfFieldEditInfo = [[[StaticNavFieldEditInfo alloc] 
			initWithCaption:LOCALIZED_STR(@"WHAT_IF_AMOUNTS_FORM_TITLE")  
			andSubtitle:LOCALIZED_STR(@"WHAT_IF_AMOUNTS_SUBTITLE") 
			andContentDescription:nil  
			andSubFormInfoCreator:whatIfFormInfoCreator] autorelease];
	[sectionInfo addFieldEditInfo:whatIfFieldEditInfo];


	whatIfFormInfoCreator = [[[WhatIfInvestmentReturnFormInfoCreator alloc] init] autorelease];
	whatIfFieldEditInfo = [[[StaticNavFieldEditInfo alloc] 
			initWithCaption:LOCALIZED_STR(@"WHAT_IF_INVESTMENT_RETURN_FIELD_CAPTION")  
			andSubtitle:LOCALIZED_STR(@"WHAT_IF_INVESTMENT_RETURN_SUBTITLE") 
			andContentDescription:nil  
			andSubFormInfoCreator:whatIfFormInfoCreator] autorelease];
	[sectionInfo addFieldEditInfo:whatIfFieldEditInfo];

	whatIfFormInfoCreator = [[[WhatIfGrowthRateFormInfoCreator alloc] init] autorelease];
	whatIfFieldEditInfo = [[[StaticNavFieldEditInfo alloc] 
			initWithCaption:LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_FIELD_CAPTION")  
			andSubtitle:LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_SUBTITLE") 
			andContentDescription:nil  
			andSubFormInfoCreator:whatIfFormInfoCreator] autorelease];
	[sectionInfo addFieldEditInfo:whatIfFieldEditInfo];
	
	whatIfFormInfoCreator = [[[WhatIfDatesFormInfoCreator alloc] init] autorelease];
	whatIfFieldEditInfo = [[[StaticNavFieldEditInfo alloc] 
			initWithCaption:LOCALIZED_STR(@"WHAT_IF_DATES_FIELD_CAPTION")  
			andSubtitle:LOCALIZED_STR(@"WHAT_IF_DATES_SUBTITLE") 
			andContentDescription:nil  
			andSubFormInfoCreator:whatIfFormInfoCreator] autorelease];
	[sectionInfo addFieldEditInfo:whatIfFieldEditInfo];


	whatIfFormInfoCreator = [[[WhatIfTaxesFormInfoCreator alloc] init] autorelease];
	whatIfFieldEditInfo = [[[StaticNavFieldEditInfo alloc] 
			initWithCaption:LOCALIZED_STR(@"WHAT_IF_TAXES_FIELD_CAPTION")  
			andSubtitle:LOCALIZED_STR(@"WHAT_IF_TAXES_SUBTITLE") 
			andContentDescription:nil  
			andSubFormInfoCreator:whatIfFormInfoCreator] autorelease];
	[sectionInfo addFieldEditInfo:whatIfFieldEditInfo];

	
	return formPopulator.formInfo;
	
}

@end


@implementation WhatIfInputsEnabledFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] initForNewObject:FALSE] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_FORM_TITLE");
	
	SectionInfo *sectionInfo;
		
	NSSet *inputs = [[DataModelController theDataModelController] fetchObjectsForEntityName:INCOME_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_INCOME");

		for(IncomeInput *income in inputs)
		{
			[formPopulator populateMultiScenBoolField:income.cashFlowEnabled withLabel:income.name];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
				fetchObjectsForEntityName:EXPENSE_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{

		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_EXPENSE");

		for(ExpenseInput *expense in inputs)
		{    
			[formPopulator populateMultiScenBoolField:expense.cashFlowEnabled withLabel:expense.name];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_ACCOUNT_CONTRIBS");
	
		for(Account *acct in inputs)
		{
			[formPopulator populateMultiScenBoolField:acct.contribEnabled withLabel:acct.name];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
			fetchObjectsForEntityName:LOAN_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_LOAN");

		for(LoanInput *loan in inputs)
		{
			[formPopulator populateMultiScenBoolField:loan.loanEnabled withLabel:loan.name];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
		fetchObjectsForEntityName:ASSET_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_ASSET");
		
		for(AssetInput *asset in inputs)
		{
			[formPopulator populateMultiScenBoolField:asset.assetEnabled withLabel:asset.name];			
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
				fetchObjectsForEntityName:LOAN_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_LOAN_EXTRA_PMT");

		for(LoanInput *loan in inputs)
		{
			[formPopulator populateMultiScenBoolField:loan.extraPmtEnabled withLabel:loan.name];			
		}
	}
	
	return formPopulator.formInfo;
	
}

@end


@implementation WhatIfWithdrawalsFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
	BOOL isNewObject = FALSE;
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] initForNewObject:isNewObject] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"WHAT_IF_WITHDRAWALS_FORM_TITLE");
	
	SectionInfo *sectionInfo;
	
	NSSet *inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_WITHDRAWAL_PRIORITY_SECTION_TITLE");
	
		for(Account *acct in inputs)
		{
			[formPopulator populateMultiScenFixedValField:acct.withdrawalPriority 
				andValLabel:acct.name
				andPrompt:LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_PRIORITY_PLACEHOLDER")
				andValidator:[[[PositiveNumberValidator alloc] init] autorelease]];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_WITHDRAWAL_DEFERRED_SECTION_TITLE");
		
		for(Account *acct in inputs)
		{
			DeferredWithdrawalFieldEditInfo *deferredWithdrawalFieldInfo = 
				[[[DeferredWithdrawalFieldEditInfo alloc] initWithAccount:acct
					andFieldLabel:acct.name
					andIsNewAccount:isNewObject] autorelease];
				[sectionInfo addFieldEditInfo:deferredWithdrawalFieldInfo];

		}
	}
		
	return formPopulator.formInfo;
	
}

@end

@implementation WhatIfAmountFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] initForNewObject:FALSE] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_FORM_TITLE");
	
	SectionInfo *sectionInfo;
		
	NSSet *inputs = [[DataModelController theDataModelController] fetchObjectsForEntityName:INCOME_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_INCOME");

		for(IncomeInput *income in inputs)
		{
			[formPopulator populateMultiScenarioAmount:income.amount 
				withValueTitle:income.name
				andValueName:income.name];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
				fetchObjectsForEntityName:EXPENSE_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_EXPENSE");

		for(ExpenseInput *expense in inputs)
		{   
			[formPopulator populateMultiScenarioAmount:expense.amount 
				withValueTitle:expense.name
				andValueName:expense.name];
 		}
	}
	
	inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_ACCOUNT_CONTRIBS");
	
		for(Account *acct in inputs)
		{
			[formPopulator populateMultiScenarioAmount:acct.contribAmount 
				withValueTitle:acct.name
				andValueName:acct.name];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
			fetchObjectsForEntityName:LOAN_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_LOAN_COST");

		for(LoanInput *loan in inputs)
		{
			[formPopulator populateMultiScenarioAmount:loan.loanCost 
				withValueTitle:loan.name
				andValueName:loan.name]; 
		}
	}

	inputs = [[DataModelController theDataModelController] 
				fetchObjectsForEntityName:LOAN_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_LOAN_EXTRA_PMT");

		for(LoanInput *loan in inputs)
		{		
			[formPopulator populateMultiScenarioAmount:loan.extraPmtAmt 
				withValueTitle:loan.name
				andValueName:loan.name];
		}
	}

	
	inputs = [[DataModelController theDataModelController] 
		fetchObjectsForEntityName:ASSET_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_ASSET_COST");
		
		for(AssetInput *asset in inputs)
		{
			[formPopulator populateMultiScenarioAmount:asset.cost 
				withValueTitle:asset.name
				andValueName:asset.name];
		}
	}
	
	
	return formPopulator.formInfo;
	
}

@end


@implementation WhatIfInvestmentReturnFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] initForNewObject:FALSE] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"WHAT_IF_INVESTMENT_RETURN_FORM_TITLE");
	
	SectionInfo *sectionInfo;
		
	NSSet *inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_RETURN_ACCOUNT_INTEREST");
	
		for(Account *acct in inputs)
		{
			[formPopulator populateMultiScenarioInvestmentReturnRate:acct.interestRate 
				withLabel:acct.name
				andValueName:acct.name];
		}
	}
	
	
	inputs = [[DataModelController theDataModelController] 
		fetchObjectsForEntityName:ASSET_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_RETURN_ASSET_APPRECIATION");
		
		for(AssetInput *asset in inputs)
		{
			[formPopulator populateMultiScenarioApprecRate:asset.apprecRate 
				withLabel:asset.name
				andValueName:asset.name]; 
		}
	}
	
	
	return formPopulator.formInfo;
	
}

@end

@implementation WhatIfGrowthRateFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] initForNewObject:FALSE] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_FORM_TITLE");
	
	SectionInfo *sectionInfo;
		
	NSSet *inputs = [[DataModelController theDataModelController] fetchObjectsForEntityName:INCOME_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_INCOME");

		for(IncomeInput *income in inputs)
		{
			[formPopulator populateMultiScenarioGrowthRate:income.amountGrowthRate 
				withLabel:income.name
				andValueName:income.name];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
				fetchObjectsForEntityName:EXPENSE_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{

		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_EXPENSE");

		for(ExpenseInput *expense in inputs)
		{    
			[formPopulator populateMultiScenarioGrowthRate:expense.amountGrowthRate 
				withLabel:expense.name
				andValueName:expense.name];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_ACCOUNT_CONTRIBS");
	
		for(Account *acct in inputs)
		{
			[formPopulator populateMultiScenarioGrowthRate:acct.contribGrowthRate 
				withLabel:acct.name 
				andValueName:acct.name];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
			fetchObjectsForEntityName:LOAN_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_LOAN_EXTRA_PMT");

		for(LoanInput *loan in inputs)
		{
			[formPopulator populateMultiScenarioGrowthRate:loan.extraPmtGrowthRate 
				withLabel:loan.name
				andValueName:loan.name];
		}
	}

	inputs = [[DataModelController theDataModelController] 
			fetchObjectsForEntityName:LOAN_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_LOAN_COST");

		for(LoanInput *loan in inputs)
		{
			[formPopulator populateMultiScenarioGrowthRate:loan.loanCostGrowthRate 
				withLabel:loan.name
				andValueName:loan.name];
		}
	}


	inputs = [[DataModelController theDataModelController] 
			fetchObjectsForEntityName:LOAN_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_LOAN_INTEREST");

		for(LoanInput *loan in inputs)
		{
			[formPopulator populateMultiScenarioInterestRate:loan.interestRate 
				withLabel:loan.name 
				andValueName:loan.name];
		}
	}
	
	// TODO - Add growth rates for TaxInput std deduction and exemption


	return formPopulator.formInfo;
	
}

@end

@implementation WhatIfTaxesFormInfoCreator


- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"WHAT_IF_TAXES_FORM_TITLE");
	
	// TODO - Need to migrate the inputs referenced below over to the multi-scenario
	// boolean values, in which case the currentScenario local variable will be 
	// needed.
	// Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].defaultScenario;
	
	// TODO - Put Tax exemption amounts, standard deductions, enabled/disabled here


	return formPopulator.formInfo;
	
}

@end



@implementation WhatIfDatesFormInfoCreator


- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] initForNewObject:FALSE] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"WHAT_IF_DATES_FORM_TITLE");
	
	SectionInfo *sectionInfo;
		
	NSSet *inputs = [[DataModelController theDataModelController] fetchObjectsForEntityName:INCOME_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_DATES_INCOME_START");

		for(IncomeInput *income in inputs)
		{
			[formPopulator populateMultiScenSimDate:income.startDate 
				andLabel:income.name 
				andTitle:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TITLE")
				andTableHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TABLE_HEADER_FORMAT"),[income inputTypeTitle]] 
				andTableSubHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TABLE_SUBHEADER_FORMAT"),
					[income inlineInputType],income.name]];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
				fetchObjectsForEntityName:EXPENSE_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{

		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_DATES_EXPENSE_START");

		for(ExpenseInput *expense in inputs)
		{    
			[formPopulator populateMultiScenSimDate:expense.startDate 
				andLabel:expense.name 
				andTitle:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TITLE")
				andTableHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TABLE_HEADER_FORMAT"),[expense inputTypeTitle]] 
				andTableSubHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TABLE_SUBHEADER_FORMAT"),
					[expense inlineInputType],expense.name]];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ACCOUNT_CONTRIB_START");
	
		for(Account *acct in inputs)
		{
			[formPopulator populateMultiScenSimDate:acct.contribStartDate 
				andLabel:acct.name 
				andTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_START_DATE_TITLE")
				andTableHeader:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_START_DATE_TABLE_HEADER") 
				andTableSubHeader:[NSString stringWithFormat:
					LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_START_DATE_TABLE_SUBHEADER_FORMAT"),
					[acct inlineInputType],acct.name]];	
		}
	}

	
	inputs = [[DataModelController theDataModelController] 
			fetchObjectsForEntityName:LOAN_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_DATES_LOAN_ORIG");

		for(LoanInput *loan in inputs)
		{
			[formPopulator populateMultiScenSimDate:loan.origDate 
				andLabel:loan.name 
				andTitle:LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_FIELD_LABEL")
				andTableHeader:LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_TABLE_HEADER") 
				andTableSubHeader:[NSString stringWithFormat:
					LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_SUBHEADER_FORMAT"),loan.name]];
		}
	}

	
	
	inputs = [[DataModelController theDataModelController] 
		fetchObjectsForEntityName:ASSET_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_DATES_ASSET_PURCHASE");
		
		for(AssetInput *asset in inputs)
		{
			[formPopulator populateMultiScenSimDate:asset.purchaseDate 
				andLabel:asset.name 
				andTitle:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_TITLE")
				andTableHeader:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_TABLE_HEADER")
				 andTableSubHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_TABLE_SUBHEADER_FORMAT"),asset.name]];
		}
	}



	inputs = [[DataModelController theDataModelController] fetchObjectsForEntityName:INCOME_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_DATES_INCOME_END");

		for(IncomeInput *income in inputs)
		{
			[formPopulator populateMultiScenSimEndDate:income.endDate 
				andLabel:income.name 
				andTitle:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TABLE_TITLE")
				andTableHeader:[NSString 
					stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TABLE_HEADER_FORMAT"),
						[income inputTypeTitle]]
				 andTableSubHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TABLE_SUBHEADER_FORMAT"),[income inlineInputType],income.name]
				andNeverEndFieldTitle:LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_LABEL")
				andNeverEndFieldSubtitle:LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_SUBTITLE")
				andNeverEndSectionTitle:LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_SECTION_TITLE") 
				andNeverEndSectionSubtitle:LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_SECTION_SUBTITLE")
				andRelEndDateSectionTitle:LOCALIZED_STR(@"SIM_DATE_RELATIVE_ENDING_DATE_SECTION_TITLE") 
				andRelEndDateSectionSubtitle:LOCALIZED_STR(@"SIM_DATE_RELATIVE_ENDING_DATE_SECTION_SUBTITLE")
				andRelEndDateFieldLabel:LOCALIZED_STR(@"RELATIVE_END_DATE_FIELD_LABEL")];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
				fetchObjectsForEntityName:EXPENSE_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{

		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_DATES_EXPENSE_END");

		for(ExpenseInput *expense in inputs)
		{    
			[formPopulator populateMultiScenSimEndDate:expense.endDate 
				andLabel:expense.name 
				andTitle:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TABLE_TITLE")
				andTableHeader:[NSString 
					stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TABLE_HEADER_FORMAT"),
						[expense inputTypeTitle]]
				 andTableSubHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TABLE_SUBHEADER_FORMAT"),[expense inlineInputType],expense.name]
				andNeverEndFieldTitle:LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_LABEL")
				andNeverEndFieldSubtitle:LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_SUBTITLE")
				andNeverEndSectionTitle:LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_SECTION_TITLE") 
				andNeverEndSectionSubtitle:LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_SECTION_SUBTITLE")
				andRelEndDateSectionTitle:LOCALIZED_STR(@"SIM_DATE_RELATIVE_ENDING_DATE_SECTION_TITLE") 
				andRelEndDateSectionSubtitle:LOCALIZED_STR(@"SIM_DATE_RELATIVE_ENDING_DATE_SECTION_SUBTITLE")
				andRelEndDateFieldLabel:LOCALIZED_STR(@"RELATIVE_END_DATE_FIELD_LABEL")];
		}
	}

	inputs = [[DataModelController theDataModelController] 
		fetchObjectsForEntityName:ASSET_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_DATES_ASSET_SALE");
		
		for(AssetInput *asset in inputs)
		{
			[formPopulator populateMultiScenSimEndDate:asset.saleDate 
				andLabel:asset.name 
				andTitle:LOCALIZED_STR(@"INPUT_ASSET_SALE_DATE_TITLE")
					andTableHeader:LOCALIZED_STR(@"INPUT_ASSET_SELL_DATE_TABLE_TITLE")
					andTableSubHeader:[NSString stringWithFormat:
						LOCALIZED_STR(@"INPUT_ASSET_SELL_DATE_TABLE_SUBTITLE_FORMAT"),asset.name]
						andNeverEndFieldTitle:LOCALIZED_STR(@"INPUT_ASSET_NEVER_SELL_FIELD_TITLE") 
						andNeverEndFieldSubtitle:LOCALIZED_STR(@"INPUT_ASSET_NEVER_SELL_FIELD_SUBTITLE")
						andNeverEndSectionTitle:LOCALIZED_STR(@"INPUT_ASSET_NEVER_SELL_SECTION_TITLE") 
						andNeverEndSectionSubtitle:LOCALIZED_STR(@"INPUT_ASSET_NEVER_SELL_SECTION_SUBTITLE")
						andRelEndDateSectionTitle:LOCALIZED_STR(@"INPUT_ASSET_SALE_REL_END_DATE_SECTION_TITLE")
						andRelEndDateSectionSubtitle:LOCALIZED_STR(@"INPUT_ASSET_SALE_REL_END_DATE_SECTION_SUBTITLE")
						andRelEndDateFieldLabel:LOCALIZED_STR(@"INPUT_ASSET_SALE_REL_END_DATE_FIELD_LABEL")
						];
		}
	}

	inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ACCOUNT_CONTRIB_END");
	
		for(Account *acct in inputs)
		{
			[formPopulator populateMultiScenSimEndDate:acct.contribEndDate 
				andLabel:acct.name
				andTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_END_DATE_TABLE_TITLE")
				andTableHeader:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_END_DATE_TABLE_HEADER")
				 andTableSubHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_END_DATE_TABLE_SUBHEADER_FORMAT"),acct.name]

				andNeverEndFieldTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_NEVER_END_FIELD_TITLE")
				andNeverEndFieldSubtitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_NEVER_END_FIELD_SUBTITLE")
				andNeverEndSectionTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_NEVER_END_SECTION_TITLE") 
				andNeverEndSectionSubtitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_NEVER_END_SECTION_SUBTITLE")
				andRelEndDateSectionTitle:LOCALIZED_STR(@"SIM_DATE_RELATIVE_ENDING_DATE_SECTION_TITLE") 
				andRelEndDateSectionSubtitle:LOCALIZED_STR(@"SIM_DATE_RELATIVE_ENDING_DATE_SECTION_SUBTITLE")
				andRelEndDateFieldLabel:LOCALIZED_STR(@"RELATIVE_END_DATE_FIELD_LABEL")];
		}
	}


	inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ACCOUNT_DEFERRED_WITHDRAWAL");
	
		for(Account *acct in inputs)
		{
			[formPopulator populateMultiScenSimDate:acct.deferredWithdrawalDate 
				andLabel:acct.name
				andTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_DEFERRED_WITHDRAW_DATE_TITLE")
				andTableHeader:LOCALIZED_STR(@"INPUT_ACCOUNT__DEFERRED_WITHDRAW_DATE_TABLE_HEADER")
				 andTableSubHeader:[NSString stringWithFormat:
					LOCALIZED_STR(@"INPUT_ACCOUNT_DEFERRED_WITHDRAW_DATE_TABLE_SUBHEADER_FORMAT"),
					acct.name]];
		}
	}


	return formPopulator.formInfo;
	
}

@end