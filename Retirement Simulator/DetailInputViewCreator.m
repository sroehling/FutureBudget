//
//  DetailInputViewCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailInputViewCreator.h"
#import "ExpenseInput.h"
#import "IncomeInput.h"
#import "NumberHelper.h"
#import "ManagedObjectFieldInfo.h"
#import "NumberFieldEditInfo.h"
#import "DateFieldEditInfo.h"
#import "SimDateFieldEditInfo.h"
#import "RepeatFrequencyFieldEditInfo.h"
#import "DateSensitiveValueFieldEditInfo.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "EventRepeatFrequency.h"
#import "VariableValueRuntimeInfo.h"
#import "SectionInfo.h"
#import "FormInfo.h"
#import "FormPopulator.h"
#import "SharedEntityVariableValueListMgr.h"
#import "LocalizationHelper.h"
#import "SimDateRuntimeInfo.h"
#import "SharedAppValues.h"
#import "Account.h"
#import "DataModelController.h"
#import "SharedAppValues.h"
#import "SavingsAccount.h"
#import "BoolFieldEditInfo.h"
#import "MultiScenarioInputValueFieldInfo.h"
#import "VariableValueRuntimeInfo.h"
#import "MultiScenarioBoolInputValueFieldInfo.h"
#import "NameFieldEditInfo.h"
#import "AccountContribAmountVariableValueListMgr.h"
#import "LoanInputVariableValueListMgr.h"
#import "CashFlowAmountVariableValueListMgr.h"
#import "MultiScenarioFixedValueFieldInfo.h"
#import "LoanInput.h"
#import "LoanDownPmtPercent.h"
#import "AssetInput.h"
#import "AssetCostVariableValueListMgr.h"
#import "DeferredWithdrawalFieldEditInfo.h"
#import "TaxInput.h"
#import "MultiScenarioAmount.h"
#import "MultiScenarioAmountVariableValueListMgr.h"
#import "MultiScenarioGrowthRate.h"
#import "SharedEntityVariableValueListMgr.h"
#import "InflationRate.h"
#import "ItemizedTaxAmtsFormInfoCreator.h"
#import "StaticNavFieldEditInfo.h"
#import "ItemizedTaxAmtsInfo.h"
#import "TaxBracketFormInfoCreator.h"

#import "InputFormPopulator.h"

@implementation DetailInputViewCreator

@synthesize input;
@synthesize isForNewObject;
@synthesize formPopulator;

-(id) initWithInput:(Input*)theInput andIsForNewObject:(BOOL)forNewObject
{
    self = [super init];
    if(self)
    {
        assert(theInput!=nil);
        self.input = theInput;
		
		self.isForNewObject = forNewObject;
    }
    return self;
}

-(id) init
{
    assert(0); // should not be called
}


- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    self.formPopulator = [[[InputFormPopulator alloc] initForNewObject:self.isForNewObject] autorelease];
    
    [self.input acceptInputVisitor:self];
    
    return formPopulator.formInfo;

}



- (void) visitCashFlow:(CashFlowInput *)cashFlow
{

	[self.formPopulator populateInputNameField:cashFlow];
	
 	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].defaultScenario;
	      
    // Amount section
    
    SectionInfo *sectionInfo  = [formPopulator nextSection];
	
	
	[self.formPopulator populateMultiScenBoolField:cashFlow.multiScenarioCashFlowEnabled withLabel:LOCALIZED_STR(@"INPUT_CASH_FLOW_ENABLED_FIELD_LABEL")];

    sectionInfo.title = 
		LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_SECTION_TITLE");
	
	
	CashFlowAmountVariableValueListMgr *variableAmountMgr = 
		[[[CashFlowAmountVariableValueListMgr alloc] initWithCashFlow:cashFlow] autorelease];
	VariableValueRuntimeInfo *varValRuntimeInfo =  [VariableValueRuntimeInfo createForVariableAmount:cashFlow 
		andVariableValListMgr:variableAmountMgr];
    [sectionInfo addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForScenario:currentScenario andObject:cashFlow 
		andKey:CASH_FLOW_INPUT_MULTI_SCENARIO_AMOUNT_KEY 
	  andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_AMOUNT_FIELD_LABEL") 
	  andValRuntimeInfo:varValRuntimeInfo
	  andDefaultFixedVal:cashFlow.multiScenarioFixedAmount]];

    [sectionInfo addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForScenario:currentScenario andObject:cashFlow 
			andKey:CASH_FLOW_INPUT_MULTI_SCENARIO_AMOUNT_GROWTH_RATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_GROWTH_RATE_FIELD_LABEL") 
		 andValRuntimeInfo:[VariableValueRuntimeInfo createForSharedInflationRate:cashFlow] 
		 andDefaultFixedVal:cashFlow.multiScenarioFixedGrowthRate]];

    // Occurences section

    sectionInfo = [formPopulator nextSection];
    sectionInfo.title = LOCALIZED_STR(@"INPUT_CASHFLOW_OCCURRENCES_SECTION_TITLE");

	
    
	SimDateRuntimeInfo *startDateInfo = 
		[SimDateRuntimeInfo createForInput:cashFlow andFieldTitleKey:@"INPUT_CASH_FLOW_START_DATE_TITLE" andSubHeaderFormatKey:@"INPUT_CASH_FLOW_START_DATE_SUBHEADER_FORMAT" andSubHeaderFormatKeyNoName:@"INPUT_CASH_FLOW_START_DATE_SUBHEADER_FORMAT_NO_NAME"];
    [sectionInfo addFieldEditInfo:[SimDateFieldEditInfo createForMultiScenarioVal:currentScenario 
			andObject:cashFlow andKey:CASH_FLOW_INPUT_MULTI_SCENARIO_START_DATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_START_FIELD_LABEL") 
			andDefaultValue:cashFlow.multiScenarioFixedStartDate 
			andVarDateRuntimeInfo:startDateInfo andShowEndDates:FALSE
			
			andDefaultRelEndDate:nil]];
	

	RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = 
		[self.formPopulator populateRepeatFrequency:cashFlow
		andFreqKey:CASH_FLOW_INPUT_MULTI_SCENARIO_EVENT_REPEAT_FREQUENCY_KEY 
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_REPEAT_FIELD_LABEL")];

    
    // Only display (and prompt for) and end date when/if the repeat frequency is set to something other
    // than "Once", such that an end date is needed. TBD - Should the end date in this case default to 
    // "Plan end date".
     if([repeatFrequencyInfo.fieldInfo fieldIsInitializedInParentObject])
    {
        EventRepeatFrequency *repeatFreq = (EventRepeatFrequency*)[repeatFrequencyInfo.fieldInfo getFieldValue];
        assert(repeatFreq != nil);
        if([repeatFreq  eventRepeatsMoreThanOnce])
        {
			SimDateRuntimeInfo *endDateInfo = 
			[SimDateRuntimeInfo createForInput:cashFlow andFieldTitleKey:@"INPUT_CASH_FLOW_END_DATE_TITLE" andSubHeaderFormatKey:@"INPUT_CASH_FLOW_END_DATE_SUBHEADER_FORMAT" andSubHeaderFormatKeyNoName:@"INPUT_CASH_FLOW_END_DATE_SUBHEADER_FORMAT_NO_NAME"];

			[sectionInfo addFieldEditInfo:[SimDateFieldEditInfo createForMultiScenarioVal:currentScenario 
				andObject:cashFlow andKey:CASH_FLOW_INPUT_MULTI_SCENARIO_END_DATE_KEY 
				andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_END_FIELD_LABEL") 
				andDefaultValue:cashFlow.multiScenarioFixedEndDate 
				andVarDateRuntimeInfo:endDateInfo andShowEndDates:TRUE
				andDefaultRelEndDate:cashFlow.multiScenarioFixedRelEndDate]];
			
        }
        
    }
    
}

- (void)visitExpense:(ExpenseInput*)expense
{    
    formPopulator.formInfo.title = 
	       LOCALIZED_STR(@"INPUT_EXPENSE_VIEW_TITLE");
		   
	SectionInfo *sectionInfo = [formPopulator nextSection];
    sectionInfo.title = LOCALIZED_STR(@"INPUT_EXPENSE_TAXES_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"INPUT_EXPENSE_TAXES_SECTION_SUBTITLE");
	[sectionInfo addFieldEditInfo:
        [BoolFieldEditInfo createForObject:expense 
			andKey:EXPENSE_INPUT_TAX_DEDUCTIBLE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_EXPENSE_TAXES_TAX_DEDUCTIBLE_LABEL")]];
	
	   
}

- (void)visitIncome:(IncomeInput*)input
{
    formPopulator.formInfo.title = 
		LOCALIZED_STR(@"INPUT_INCOME_VIEW_TITLE");
}

- (void) visitAccount:(Account*)account
{
    formPopulator.formInfo.title = 
		LOCALIZED_STR(@"INPUT_ACCOUNT_TITLE");
	[self.formPopulator populateInputNameField:account];

 	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].defaultScenario;
	
	SectionInfo *sectionInfo = [formPopulator nextSection];

	[self.formPopulator populateCurrencyField:account andValKey:ACCOUNT_STARTING_BALANCE_KEY
		andLabel:LOCALIZED_STR(@"INPUT_SAVINGS_ACCOUNT_STARTING_BALANCE_LABEL") 
			andPlaceholder:LOCALIZED_STR(@"INPUT_ACCOUNT_STARTING_BALANCE_PLACEHOLDER")];

	sectionInfo = [formPopulator nextSection];
    sectionInfo.title = LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_AMOUNT_SECTION_TITLE");
		
		
	[self.formPopulator populateMultiScenBoolField:account.multiScenarioContribEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_ENABLED_LABEL")];
		
	
	AccountContribAmountVariableValueListMgr *variableAmountMgr = 
		[[[AccountContribAmountVariableValueListMgr alloc] initWithAccount:account] autorelease];
	VariableValueRuntimeInfo *varValRuntimeInfo = [VariableValueRuntimeInfo createForVariableAmount:account 
		andVariableValListMgr:variableAmountMgr];
    [sectionInfo addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForScenario:currentScenario andObject:account 
		andKey:ACCOUNT_MULTI_SCEN_CONTRIB_AMOUNT_KEY 
	  andLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_AMOUNT_FIELD_LABEL") 
	  andValRuntimeInfo:varValRuntimeInfo
	  andDefaultFixedVal:account.multiScenarioFixedContribAmount]];
	  
    [sectionInfo addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForScenario:currentScenario andObject:account 
			andKey:ACCOUNT_MULTI_SCEN_CONTRIB_GROWTH_RATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_GROWTH_RATE_FIELD_LABEL") 
		 andValRuntimeInfo:[VariableValueRuntimeInfo createForSharedInflationRate:account] 
		 andDefaultFixedVal:account.multiScenarioFixedContribGrowthRate]];

	SimDateRuntimeInfo *startDateInfo = 
		[SimDateRuntimeInfo createForInput:account andFieldTitleKey:@"INPUT_CASH_FLOW_START_DATE_TITLE" andSubHeaderFormatKey:@"INPUT_CASH_FLOW_START_DATE_SUBHEADER_FORMAT" andSubHeaderFormatKeyNoName:@"INPUT_CASH_FLOW_START_DATE_SUBHEADER_FORMAT_NO_NAME"];
    [sectionInfo addFieldEditInfo:[SimDateFieldEditInfo createForMultiScenarioVal:currentScenario 
			andObject:account andKey:ACCOUNT_MULTI_SCEN_CONTRIB_START_DATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_START_FIELD_LABEL") 
			andDefaultValue:account.multiScenarioFixedContribStartDate 
			andVarDateRuntimeInfo:startDateInfo andShowEndDates:FALSE
			andDefaultRelEndDate:nil]];


	RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = 
		[self.formPopulator populateRepeatFrequency:account
		andFreqKey:ACCOUNT_MULTI_SCEN_CONTRIB_REPEAT_FREQUENCY_KEY 
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_REPEAT_FIELD_LABEL")];

    
    // Only display (and prompt for) and end date when/if the repeat frequency is set to something other
    // than "Once", such that an end date is needed. TBD - Should the end date in this case default to 
    // "Plan end date".
	if([repeatFrequencyInfo.fieldInfo fieldIsInitializedInParentObject])	
    {
        EventRepeatFrequency *repeatFreq = (EventRepeatFrequency*)[repeatFrequencyInfo.fieldInfo getFieldValue];
        assert(repeatFreq != nil);
        if([repeatFreq  eventRepeatsMoreThanOnce])
        {
			SimDateRuntimeInfo *endDateInfo = 
			[SimDateRuntimeInfo createForInput:account andFieldTitleKey:@"INPUT_CASH_FLOW_END_DATE_TITLE" andSubHeaderFormatKey:@"INPUT_CASH_FLOW_END_DATE_SUBHEADER_FORMAT" andSubHeaderFormatKeyNoName:@"INPUT_CASH_FLOW_END_DATE_SUBHEADER_FORMAT_NO_NAME"];

			// TODO - Add fixed relative end date
			[sectionInfo addFieldEditInfo:[SimDateFieldEditInfo createForMultiScenarioVal:currentScenario 
				andObject:account andKey:ACCOUNT_MULTI_SCEN_CONTRIB_END_DATE_KEY 
				andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_END_FIELD_LABEL") 
				andDefaultValue:account.multiScenarioFixedContribEndDate 
				andVarDateRuntimeInfo:endDateInfo andShowEndDates:TRUE
				andDefaultRelEndDate:account.multiScenarioFixedContribRelEndDate]];
			
        }
        
    }

}

- (void) visitSavingsAccount:(SavingsAccount *)savingsAcct
{
		
	 Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].currentInputScenario;

	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title =LOCALIZED_STR(@"INPUT_ACCOUNT_INTEREST_SECTION_TITLE");
	
    [sectionInfo addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForScenario:currentScenario andObject:savingsAcct 
		andKey:SAVINGS_ACCOUNT_INTEREST_RATE_KEY 
	  andLabel:LOCALIZED_STR(@"INPUT_SAVINGS_ACCOUNT_INTEREST_RATE_FIELD_LABEL") 
	  andValRuntimeInfo:[VariableValueRuntimeInfo createForSharedInterestRate:savingsAcct]
	  andDefaultFixedVal:savingsAcct.multiScenarioFixedInterestRate]];


	[sectionInfo addFieldEditInfo:
        [BoolFieldEditInfo createForObject:savingsAcct 
			andKey:SAVINGS_ACCOUNT_TAXABLE_INTEREST_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_SAVINGS_ACCOUNT_TAXABLE_INTEREST_LABEL")]];


	sectionInfo = [formPopulator nextSection];
	sectionInfo.title =LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWALS_SECTION_TITLE");

	[self.formPopulator populateMultiScenFixedValField:savingsAcct.multiScenarioWithdrawalPriority andValLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_PRIORITY_LABEL") 
		andPrompt:LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_PRIORITY_PLACEHOLDER")];
	
	DeferredWithdrawalFieldEditInfo *deferredWithdrawalFieldInfo = 
		[[[DeferredWithdrawalFieldEditInfo alloc] initWithAccount:savingsAcct
			andFieldLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_DEFER_WITHDRAWALS_LABEL")] autorelease];
	[sectionInfo addFieldEditInfo:deferredWithdrawalFieldInfo];

	[sectionInfo addFieldEditInfo:
        [BoolFieldEditInfo createForObject:savingsAcct 
			andKey:SAVINGS_ACCOUNT_TAXABLE_WITHDRAWALS_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_SAVINGS_ACCOUNT_TAXABLE_WITHDRAWAL_LABEL")]];
	
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = 
		LOCALIZED_STR(@"INPUT_SAVINGS_ACCOUNT_TAXES_SECTION_TITLE");
	
	[sectionInfo addFieldEditInfo:
        [BoolFieldEditInfo createForObject:savingsAcct 
			andKey:SAVINGS_ACCOUNT_TAXABLE_CONTRIBUTIONS_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_SAVINGS_ACCOUNT_TAXABLE_CONTRIBUTION_LABEL")]];

}

- (void) visitLoan:(LoanInput*)loan
{
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_LOAN_TITLE");
	[self.formPopulator populateInputNameField:loan];
	
	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].currentInputScenario;

	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_LOAN_COST_SECTION_TITLE");
	
	
	[self.formPopulator populateMultiScenBoolField:loan.multiScenarioLoanEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_LOAN_ENABLED_FIELD_LABEL")];


	LoanCostAmtVariableValueListMgr *variableAmountMgr = 
		[[[LoanCostAmtVariableValueListMgr alloc] initWithLoan:loan] autorelease];
	VariableValueRuntimeInfo *varValRuntimeInfo = [VariableValueRuntimeInfo createForVariableAmount:loan 
		andVariableValListMgr:variableAmountMgr];
	[sectionInfo addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForScenario:currentScenario andObject:loan 
		andKey:INPUT_LOAN_MULTI_SCEN_LOAN_COST_AMT_KEY 
	  andLabel:LOCALIZED_STR(@"INPUT_LOAN_LOAN_COST_AMT_FIELD_LABEL") 
	  andValRuntimeInfo:varValRuntimeInfo
	  andDefaultFixedVal:loan.multiScenarioLoanCostAmtFixed]];
	  
	[sectionInfo addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForScenario:currentScenario andObject:loan 
			andKey:INPUT_LOAN_MULTI_SCEN_LOAN_COST_GROWTH_RATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_LOAN_COST_GROWTH_RATE_FIELD_LABEL") 
		 andValRuntimeInfo:[VariableValueRuntimeInfo createForSharedInflationRate:loan] 
		 andDefaultFixedVal:loan.multiScenarioLoanCostGrowthRateFixed]];
 
	
	SimDateRuntimeInfo *origDateInfo = 
		[SimDateRuntimeInfo createForInput:loan 
			andFieldTitleKey:@"INPUT_LOAN_ORIG_DATE_FIELD_LABEL" andSubHeaderFormatKey:@"INPUT_LOAN_ORIG_DATE_SUBHEADER_FORMAT" 
			andSubHeaderFormatKeyNoName:@"INPUT_LOAN_ORIG_DATE_DATE_SUBHEADER_FORMAT_NO_NAME"];
    [sectionInfo addFieldEditInfo:[SimDateFieldEditInfo createForMultiScenarioVal:currentScenario 
			andObject:loan andKey:LOAN_MULTI_SCEN_ORIG_DATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_FIELD_LABEL") 
			andDefaultValue:loan.multiScenarioOrigDateFixed 
			andVarDateRuntimeInfo:origDateInfo andShowEndDates:FALSE
			andDefaultRelEndDate:nil]];

	[self.formPopulator populateMultiScenarioDuration:loan.multiScenarioLoanDuration 
		andLabel:LOCALIZED_STR(@"INPUT_LOAN_DURATION_LABEL") 
		andPlaceholder:LOCALIZED_STR(@"INPUT_LOAN_DURATION_PLACEHOLDER") ];

	
	[self.formPopulator populateCurrencyField:loan andValKey:INPUT_LOAN_STARTING_BALANCE_KEY 
		andLabel:LOCALIZED_STR(@"INPUT_LOAN_STARTING_BALANCE_LABEL") 
		andPlaceholder:LOCALIZED_STR(@"INPUT_LOAN_STARTING_BALANCE_PLACEHOLDER")];
			 
	sectionInfo = [formPopulator nextSection]; 
	sectionInfo.title = LOCALIZED_STR(@"INPUT_LOAN_INTEREST_SECTION_TITLE");
	
	
	[sectionInfo addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForScenario:currentScenario andObject:loan 
		andKey:LOAN_INTEREST_RATE_KEY 
	  andLabel:LOCALIZED_STR(@"INPUT_LOAN_INTEREST_RATE_FIELD_LABEL") 
	  andValRuntimeInfo:[VariableValueRuntimeInfo createForSharedInterestRate:loan]
	  andDefaultFixedVal:loan.multiScenarioInterestRateFixed]];

	
	
	[sectionInfo addFieldEditInfo:
        [BoolFieldEditInfo createForObject:loan 
			andKey:LOAN_INPUT_TAXABLE_INTEREST_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_LOAN_TAXABLE_INTEREST_LABEL")]];
			

	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_SECTION_TITLE");


	[self.formPopulator populateMultiScenBoolField:loan.multiScenarioExtraPmtEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_ENABLED_LABEL")];
	
	LoanExtraPmtAmountVariableValueListMgr *extraPmtVariableAmountMgr = 
		[[[LoanExtraPmtAmountVariableValueListMgr alloc] initWithLoan:loan] autorelease];
	VariableValueRuntimeInfo *extraPmtVarValRuntimeInfo = [VariableValueRuntimeInfo createForVariableAmount:loan 
		andVariableValListMgr:extraPmtVariableAmountMgr];	
    [sectionInfo addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForScenario:currentScenario andObject:loan 
		andKey:INPUT_LOAN_MULTI_SCEN_EXTRA_PMT_AMT_KEY 
	  andLabel:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_AMT_AMOUNT_FIELD_LABEL") 
	  andValRuntimeInfo:extraPmtVarValRuntimeInfo
	  andDefaultFixedVal:loan.multiScenarioExtraPmtAmtFixed]];
	  
	[sectionInfo addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForScenario:currentScenario andObject:loan 
			andKey:INPUT_LOAN_MULTI_SCEN_EXTRA_PMT_GROWTH_RATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_GROWTH_RATE_FIELD_LABEL") 
		 andValRuntimeInfo:[VariableValueRuntimeInfo createForSharedInflationRate:loan] 
		 andDefaultFixedVal:loan.multiScenarioExtraPmtGrowthRateFixed]];

		
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_LOAN_DOWN_PMT_SECTION_TITLE");


	[self.formPopulator populateMultiScenBoolField:loan.multiScenarioDownPmtEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_LOAN_DOWN_PMT_ENABLED_LABEL")];
	
	
	VariableValueRuntimeInfo *downPmtVarValRuntimeInfo = [VariableValueRuntimeInfo createForSharedPercentageRate:loan andSharedValEntityName:LOAN_DOWN_PMT_PERCENT_ENTITY_NAME];
    [sectionInfo addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForScenario:currentScenario andObject:loan 
		andKey:INPUT_LOAN_MULTI_SCEN_DOWN_PMT_PERCENT_KEY 
	  andLabel:LOCALIZED_STR(@"INPUT_LOAN_DOWN_PMT_PERCENT_FIELD_LABEL") 
	  andValRuntimeInfo:downPmtVarValRuntimeInfo
	  andDefaultFixedVal:loan.multiScenarioDownPmtPercentFixed]];
		



}

- (void)visitAsset:(AssetInput*)asset
{
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_ASSET_TITLE");
	[self.formPopulator populateInputNameField:asset];
	
	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].currentInputScenario;

	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_ASSET_VALUE_SECTION_TITLE");
	
	
	[self.formPopulator populateMultiScenBoolField:asset.multiScenarioAssetEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_ASSET_ENABLED_FIELD_LABEL")];
	
	
	AssetCostVariableValueListMgr *variableValueMgr = 
		[[[AssetCostVariableValueListMgr alloc] initWithAsset:asset] autorelease];
	VariableValueRuntimeInfo *varValRuntimeInfo = [VariableValueRuntimeInfo 
		createForVariableAmount:asset
		andVariableValListMgr:variableValueMgr];
	[sectionInfo addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForScenario:currentScenario andObject:asset 
		andKey:INPUT_ASSET_MULTI_SCEN_COST_KEY 
	  andLabel:LOCALIZED_STR(@"INPUT_ASSET_COST_FIELD_LABEL") 
	  andValRuntimeInfo:varValRuntimeInfo
	  andDefaultFixedVal:asset.multiScenarioCostFixed]];


	[self.formPopulator populateCurrencyField:asset andValKey:INPUT_ASSET_STARTING_VALUE_KEY 
		andLabel:LOCALIZED_STR(@"INPUT_ASSET_STARTING_VALUE_LABEL") 
		andPlaceholder:LOCALIZED_STR(@"INPUT_ASSET_STARTING_VALUE_PLACEHOLDER")];

	[sectionInfo addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForScenario:currentScenario andObject:asset 
			andKey:INPUT_ASSET_MULTI_SCEN_APPREC_RATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_ASSET_VALUE_APPREC_RATE_FIELD_LABEL") 
		 andValRuntimeInfo:[VariableValueRuntimeInfo createForSharedInflationRate:asset] 
		 andDefaultFixedVal:asset.multiScenarioApprecRateFixed]];
 
 
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_SALE_SECTION_TITLE");
 
 
 	SimDateRuntimeInfo *purchaseDateInfo = 
		[SimDateRuntimeInfo createForInput:asset 
			andFieldTitleKey:@"INPUT_ASSET_PURCHASE_DATE_TITLE" 
			andSubHeaderFormatKey:@"INPUT_ASSET_PURCHASE_DATE_SUBHEADER_FORMAT" 
			andSubHeaderFormatKeyNoName:@"INPUT_ASSET_PURCHASE_DATE_SUBHEADER_FORMAT_NO_NAME"];
    [sectionInfo addFieldEditInfo:[SimDateFieldEditInfo createForMultiScenarioVal:currentScenario 
			andObject:asset andKey:ASSET_INPUT_MULTI_SCEN_PURCHASE_DATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_FIELD_LABEL") 
			andDefaultValue:asset.multiScenarioPurchaseDateFixed 
			andVarDateRuntimeInfo:purchaseDateInfo andShowEndDates:FALSE
			andDefaultRelEndDate:nil]];

 
 
	SimDateRuntimeInfo *saleDateInfo = 
			[SimDateRuntimeInfo createForInput:asset 
				andFieldTitleKey:@"INPUT_ASSET_SALE_DATE_TITLE" 
				andSubHeaderFormatKey:@"INPUT_ASSET_SALE_DATE_SUBHEADER_FORMAT" 
			andSubHeaderFormatKeyNoName:@"INPUT_ASSET_SALE_DATE_SUBHEADER_FORMAT_NO_NAME"];
	[sectionInfo addFieldEditInfo:[SimDateFieldEditInfo 
		createForMultiScenarioVal:currentScenario 
			andObject:asset andKey:ASSET_MULTI_SCEN_SALE_DATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_ASSET_SALE_DATE_FIELD_LABEL") 
			andDefaultValue:asset.multiScenarioSaleDateFixed 
			andVarDateRuntimeInfo:saleDateInfo andShowEndDates:TRUE
			andDefaultRelEndDate:asset.multiScenarioSaleDateRelativeFixed]];

 
 	[self.formPopulator populateMultiScenBoolField:asset.multiScenarioSaleProceedsTaxable 
			withLabel:LOCALIZED_STR(@"INPUT_ASSET_PROCEEDS_TAXABLE_FIELD_LABEL")];


}

- (void)visitTax:(TaxInput *)tax
{
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_TAX_TITLE");
	[self.formPopulator populateInputNameField:tax];
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	
	[self.formPopulator populateMultiScenBoolField:tax.multiScenarioTaxEnabled  
		withLabel:LOCALIZED_STR(@"INPUT_TAX_ENABLED_FIELD_LABEL")];
		
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_TAX_SOURCES_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"INPUT_TAX_SOURCES_SECTION_SUBTITLE");
	
	ItemizedTaxAmtsInfo *taxSourceInfo = [[[ItemizedTaxAmtsInfo alloc] 
		initWithItemizedTaxAmts:tax.itemizedIncomeSources 
		andTitle:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_SOURCES_TITLE")
		andAmtPrompt:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_SOURCES_AMOUNT_PROMPT")
		andItemTitle:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_SOURCE_ITEM_TITLE")] autorelease];
	ItemizedTaxAmtsFormInfoCreator *itemizedTaxSourceFormCreator = 
		[[[ItemizedTaxAmtsFormInfoCreator alloc] 
			initWithItemizedTaxAmtsInfo:taxSourceInfo andIsForNewObject:self.isForNewObject] autorelease];
	StaticNavFieldEditInfo *taxSourcesFieldEditInfo = [[[StaticNavFieldEditInfo alloc]initWithCaption:@"Tax Sources" andSubtitle:nil andContentDescription:nil andSubFormInfoCreator:itemizedTaxSourceFormCreator] autorelease];
	[sectionInfo addFieldEditInfo:taxSourcesFieldEditInfo];

	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_TAX_ADJUSTMENT_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"INPUT_TAX_ADJUSTMENT_SECTION_SUBTITLE");

	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_TAX_EXEMPTION_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"INPUT_TAX_EXEMPTION_SECTION_SUBTITLE");
	[self.formPopulator populateMultiScenarioAmount:tax.exemptionAmt 
		withValueTitle:LOCALIZED_STR(@"INPUT_TAX_EXEMPTION_AMOUNT_TITLE")];
	[self.formPopulator populateMultiScenarioGrowthRate:tax.exemptionGrowthRate 
		withLabel:LOCALIZED_STR(@"INPUT_TAX_EXEMPTION_GROWTH_RATE_LABEL")];


	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_TAX_DEDUCTION_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"INPUT_TAX_DEDUCTION_SECTION_SUBTITLE");

	[self.formPopulator populateMultiScenarioAmount:tax.stdDeductionAmt 
		withValueTitle:LOCALIZED_STR(@"INPUT_TAX_STD_DEDUCTION_TITLE")];

	[self.formPopulator populateMultiScenarioGrowthRate:tax.stdDeductionGrowthRate  
		withLabel:LOCALIZED_STR(@"INPUT_TAX_STD_DEDUCTION_GROWTH_RATE_LABEL")];
	
	sectionInfo = [formPopulator nextSection];
	TaxBracketFormInfoCreator *taxBracketFormInfoCreator =
		[[[TaxBracketFormInfoCreator alloc] initWithTaxBracket:tax.taxBracket] autorelease];
	StaticNavFieldEditInfo *taxRatesFieldEditInfo = [[[StaticNavFieldEditInfo alloc]initWithCaption:@"Tax Rates" andSubtitle:nil andContentDescription:nil andSubFormInfoCreator:taxBracketFormInfoCreator] autorelease];
	[sectionInfo addFieldEditInfo:taxRatesFieldEditInfo];

}


- (void)dealloc
{
    [formPopulator release];
    [super dealloc];
}


@end
