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
			[formPopulator populateMultiScenarioGrowthRate:acct.interestRate 
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
			[formPopulator populateMultiScenarioGrowthRate:asset.apprecRate 
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
	


	return formPopulator.formInfo;
	
}

@end