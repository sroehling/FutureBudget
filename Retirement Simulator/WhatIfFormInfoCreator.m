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
#import "SavingsAccount.h"
#import "BoolFieldEditInfo.h"
#import "LoanInput.h"
#import "SharedAppValues.h"
#import "MultiScenarioBoolInputValueFieldInfo.h"
#import "ExpenseInput.h"
#import "IncomeInput.h"
#import "AssetInput.h"
#import "MultiScenarioFixedValueFieldInfo.h"
#import "NumberFieldEditInfo.h"
#import "NumberHelper.h"
#import "DeferredWithdrawalFieldEditInfo.h"
#import "VariableValueRuntimeInfo.h"
#import "DateSensitiveValueFieldEditInfo.h"
#import "Scenario.h"
#import "ScenarioListFormInfoCreator.h"
#import "ManagedObjectFieldInfo.h"

#import "SelectableObjectTableViewControllerFactory.h"

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
	
	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].defaultScenario;
	
	NSSet *inputs = [[DataModelController theDataModelController] fetchObjectsForEntityName:INCOME_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_INCOME");

		for(IncomeInput *income in inputs)
		{
			MultiScenarioBoolInputValueFieldInfo *enabledFieldInfo =
				[[[MultiScenarioBoolInputValueFieldInfo alloc] 
					initWithFieldLabel:income.name
					andFieldPlaceholder:@"n/a" andScenario:currentScenario 
				andInputVal:income.multiScenarioCashFlowEnabled] autorelease];
			BoolFieldEditInfo *enabledFieldEditInfo = 
				[[[BoolFieldEditInfo alloc] initWithFieldInfo:enabledFieldInfo] autorelease];
			[sectionInfo addFieldEditInfo:enabledFieldEditInfo];
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
			MultiScenarioBoolInputValueFieldInfo *enabledFieldInfo =
				[[[MultiScenarioBoolInputValueFieldInfo alloc] 
					initWithFieldLabel:expense.name
					andFieldPlaceholder:@"n/a" andScenario:currentScenario 
				andInputVal:expense.multiScenarioCashFlowEnabled] autorelease];
			BoolFieldEditInfo *enabledFieldEditInfo = 
				[[[BoolFieldEditInfo alloc] initWithFieldInfo:enabledFieldInfo] autorelease];
			[sectionInfo addFieldEditInfo:enabledFieldEditInfo];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:SAVINGS_ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_ACCOUNT_CONTRIBS");
	
		for(SavingsAccount *savingsAcct in inputs)
		{
			MultiScenarioBoolInputValueFieldInfo *enabledFieldInfo =
				[[[MultiScenarioBoolInputValueFieldInfo alloc] 
					initWithFieldLabel:savingsAcct.name 
					andFieldPlaceholder:@"n/a" andScenario:currentScenario 
				andInputVal:savingsAcct.multiScenarioContribEnabled] autorelease];
			BoolFieldEditInfo *enabledFieldEditInfo = 
				[[[BoolFieldEditInfo alloc] initWithFieldInfo:enabledFieldInfo] autorelease];
			[sectionInfo addFieldEditInfo:enabledFieldEditInfo];
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
			MultiScenarioBoolInputValueFieldInfo *enabledFieldInfo =
			[[[MultiScenarioBoolInputValueFieldInfo alloc] 
				initWithFieldLabel:loan.name 
				andFieldPlaceholder:@"n/a" andScenario:currentScenario 
			andInputVal:loan.multiScenarioLoanEnabled] autorelease];
			BoolFieldEditInfo *enabledFieldEditInfo = 
			[[[BoolFieldEditInfo alloc] initWithFieldInfo:enabledFieldInfo] autorelease];
			[sectionInfo addFieldEditInfo:enabledFieldEditInfo];

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
			MultiScenarioBoolInputValueFieldInfo *enabledFieldInfo =
				[[[MultiScenarioBoolInputValueFieldInfo alloc] 
					initWithFieldLabel:asset.name 
					andFieldPlaceholder:@"n/a" andScenario:currentScenario 
				andInputVal:asset.multiScenarioAssetEnabled] autorelease];
			BoolFieldEditInfo *enabledFieldEditInfo = 
				[[[BoolFieldEditInfo alloc] initWithFieldInfo:enabledFieldInfo] autorelease];
			[sectionInfo addFieldEditInfo:enabledFieldEditInfo];
			
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
			MultiScenarioBoolInputValueFieldInfo *enableExtraPmtFieldInfo =
				[[[MultiScenarioBoolInputValueFieldInfo alloc] 
					initWithFieldLabel:loan.name 
					andFieldPlaceholder:@"n/a" andScenario:currentScenario 
				andInputVal:loan.multiScenarioExtraPmtEnabled] autorelease];
			BoolFieldEditInfo *enableExtraPmtFieldEditInfo = 
				[[[BoolFieldEditInfo alloc] initWithFieldInfo:enableExtraPmtFieldInfo] autorelease];
			[sectionInfo addFieldEditInfo:enableExtraPmtFieldEditInfo];

		}
	}
	
	return formPopulator.formInfo;
	
}

@end


@implementation WhatIfWithdrawalsFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"WHAT_IF_WITHDRAWALS_FORM_TITLE");
	
	SectionInfo *sectionInfo;
	
	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].defaultScenario;
		
	
	NSSet *inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:SAVINGS_ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_WITHDRAWAL_PRIORITY_SECTION_TITLE");
	
		for(SavingsAccount *savingsAcct in inputs)
		{
			MultiScenarioFixedValueFieldInfo *withdrawalPriorityFieldInfo =
				[[[MultiScenarioFixedValueFieldInfo alloc] 
					initWithFieldLabel:savingsAcct.name 
					andFieldPlaceholder:LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_PRIORITY_PLACEHOLDER") 
					andScenario:currentScenario 
				andInputVal:savingsAcct.multiScenarioWithdrawalPriority] autorelease];
			NumberFieldEditInfo *withdrawalPriorityEditInfo = 
				[[NumberFieldEditInfo alloc] initWithFieldInfo:withdrawalPriorityFieldInfo
					andNumberFormatter:[NumberHelper theHelper].decimalFormatter];
			[sectionInfo addFieldEditInfo:withdrawalPriorityEditInfo];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:SAVINGS_ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_WITHDRAWAL_DEFERRED_SECTION_TITLE");
		
		for(SavingsAccount *savingsAcct in inputs)
		{
			DeferredWithdrawalFieldEditInfo *deferredWithdrawalFieldInfo = 
				[[[DeferredWithdrawalFieldEditInfo alloc] initWithAccount:savingsAcct
					andFieldLabel:savingsAcct.name] autorelease];
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
				withValueTitle:LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_AMOUNT_FIELD_LABEL")];
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
				withValueTitle:LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_AMOUNT_FIELD_LABEL")];
 		}
	}
	
	inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:SAVINGS_ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_ACCOUNT_CONTRIBS");
	
		for(SavingsAccount *savingsAcct in inputs)
		{
			[formPopulator populateMultiScenarioAmount:savingsAcct.contribAmount withValueTitle:savingsAcct.name];
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
			[formPopulator populateMultiScenarioAmount:loan.loanCost withValueTitle:loan.name]; 
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
			[formPopulator populateMultiScenarioAmount:loan.extraPmtAmt withValueTitle:loan.name];
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
			[formPopulator populateMultiScenarioAmount:asset.cost withValueTitle:asset.name];
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
					fetchObjectsForEntityName:SAVINGS_ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_RETURN_SAVINGS_ACCOUNT_INTEREST");
	
		for(SavingsAccount *savingsAcct in inputs)
		{
			[formPopulator populateMultiScenarioGrowthRate:savingsAcct.interestRate withLabel:savingsAcct.name];
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
			[formPopulator populateMultiScenarioGrowthRate:asset.apprecRate withLabel:asset.name]; 
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
			[formPopulator populateMultiScenarioGrowthRate:income.amountGrowthRate withLabel:income.name];
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
			[formPopulator populateMultiScenarioGrowthRate:expense.amountGrowthRate withLabel:expense.name];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:SAVINGS_ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_ACCOUNT_CONTRIBS");
	
		for(SavingsAccount *savingsAcct in inputs)
		{
			[formPopulator populateMultiScenarioGrowthRate:savingsAcct.contribGrowthRate withLabel:savingsAcct.name];
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
			[formPopulator populateMultiScenarioGrowthRate:loan.extraPmtGrowthRate withLabel:loan.name];
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
			[formPopulator populateMultiScenarioGrowthRate:loan.loanCostGrowthRate withLabel:loan.name];
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
			[formPopulator populateMultiScenarioGrowthRate:loan.interestRate withLabel:loan.name];
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
	
	SectionInfo *sectionInfo;
	
	// TODO - Need to migrate the inputs referenced below over to the multi-scenario
	// boolean values, in which case the currentScenario local variable will be 
	// needed.
	// Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].defaultScenario;
	
	
	NSSet *inputs = [[DataModelController theDataModelController] 
				fetchObjectsForEntityName:EXPENSE_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{

		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_TAXES_EXPENSE_DEDUCTION");

		for(ExpenseInput *expense in inputs)
		{    
			[sectionInfo addFieldEditInfo:
				[BoolFieldEditInfo createForObject:expense 
					andKey:EXPENSE_INPUT_TAX_DEDUCTIBLE_KEY 
					andLabel:expense.name]];
		}
	}
	
	inputs = [[DataModelController theDataModelController] 
					fetchObjectsForEntityName:SAVINGS_ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_TAXES_ACCOUNT_CONTRIB");
	
		for(SavingsAccount *savingsAcct in inputs)
		{
			[sectionInfo addFieldEditInfo:
				[BoolFieldEditInfo createForObject:savingsAcct 
					andKey:SAVINGS_ACCOUNT_TAXABLE_CONTRIBUTIONS_KEY 
					andLabel:savingsAcct.name]];
		}
	}

	inputs = [[DataModelController theDataModelController] 
				fetchObjectsForEntityName:SAVINGS_ACCOUNT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_TAXES_ACCOUNT_WITHDRAWAL");
	
		for(SavingsAccount *savingsAcct in inputs)
		{
			[sectionInfo addFieldEditInfo:
				[BoolFieldEditInfo createForObject:savingsAcct 
					andKey:SAVINGS_ACCOUNT_TAXABLE_WITHDRAWALS_KEY 
					andLabel:savingsAcct.name]];
		}
	}

	
	inputs = [[DataModelController theDataModelController] 
			fetchObjectsForEntityName:LOAN_INPUT_ENTITY_NAME];
	if([inputs count]  > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_TAXES_LOAN_INTEREST");

		for(LoanInput *loan in inputs)
		{
			[sectionInfo addFieldEditInfo:
				[BoolFieldEditInfo createForObject:loan 
					andKey:LOAN_INPUT_TAXABLE_INTEREST_KEY 
					andLabel:loan.name]];
		}
	}


	return formPopulator.formInfo;
	
}

@end