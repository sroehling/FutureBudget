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
#import "DurationFieldEditInfo.h"
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

@implementation DetailInputViewCreator

@synthesize input;
@synthesize isForNewObject;

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
    [formPopulator release];
    formPopulator = [[FormPopulator alloc] init];
    
    [self.input acceptInputVisitor:self];
    
    return formPopulator.formInfo;

}

- (void)populateInputNameField:(Input*)theInput
{
   SectionInfo *sectionInfo = [formPopulator nextSection];
	
	ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] initWithManagedObject:theInput andFieldKey:INPUT_NAME_KEY andFieldLabel:LOCALIZED_STR(@"INPUT_NAME_FIELD_LABEL")
	 andFieldPlaceholder:LOCALIZED_STR(@"INPUT_NAME_PLACEHOLDER")] autorelease];
	 NameFieldEditInfo *fieldEditInfo = [[[NameFieldEditInfo alloc] initWithFieldInfo:fieldInfo] autorelease];
	
    [sectionInfo addFieldEditInfo:fieldEditInfo];

}

-(void)populateMultiScenarioAmount:(MultiScenarioAmount*)theAmount 
	inSection:(SectionInfo*)sectionInfo 
	withValueTitle:(NSString*)valueTitleStringFileKey
{
	MultiScenarioAmountVariableValueListMgr *variableValueMgr = 
		[[[MultiScenarioAmountVariableValueListMgr alloc] initWithMultiScenarioAmount:theAmount] autorelease];
		
	NSString *inlineType = @"TBD Type";
	NSString *valueTitle = LOCALIZED_STR(valueTitleStringFileKey);
	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].currentInputScenario;
		
	NSString *tableSubtitle = [NSString 
	 stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_TABLE_SUBTITLE_FORMAT"),
	 LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_INLINE_VALUE_TITLE"),
	 inlineType,
	 LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_INLINE_VALUE_TITLE")];
						
	VariableValueRuntimeInfo *amountRuntimeInfo = 
		[[[VariableValueRuntimeInfo alloc]
		initWithFormatter:[NumberHelper theHelper].currencyFormatter 
		andValueTitle:valueTitleStringFileKey 
		andInlineValueTitleKey:@"INPUT_CASH_FLOW_AMOUNT_INLINE_VALUE_TITLE"
		andValueVerb:@"" andPeriodDesc:@"" andListMgr:variableValueMgr
		andSingleValueSubtitleKey:@"INPUT_CASH_FLOW_AMOUNT_SINGLE_VALUE_SECTION_SUBTITLE"
		andVariableValueSubtitleKey:@"INPUT_CASH_FLOW_AMOUNT_DATE_SENSITIVE_VALUE_VARIABLE_SUBTITLE_FORMAT"
		andValuePromptKey:@"INPUT_CASH_FLOW_AMOUNT_VALUE_PROMPT"
		  andValueTypeInline:inlineType
		  andValueTypeTitle:valueTitle
		  andValueName:@"Name TBD"
		  andTableSubtitle:tableSubtitle]
		 autorelease];
		
	[sectionInfo addFieldEditInfo:
	 [DateSensitiveValueFieldEditInfo 
	  createForScenario:currentScenario andObject:theAmount 
		andKey:MULTI_SCEN_AMOUNT_AMOUNT_KEY 
	  andLabel:valueTitle
	  andValRuntimeInfo:amountRuntimeInfo
	  andDefaultFixedVal:theAmount.defaultFixedAmount]];
}

-(void)populateBoolField:(MultiScenarioInputValue*)boolVal inSection:(SectionInfo*)sectionInfo
	withLabel:(NSString*)labelStringFileKey
{

	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].currentInputScenario;

	MultiScenarioBoolInputValueFieldInfo *enabledFieldInfo =
		[[[MultiScenarioBoolInputValueFieldInfo alloc] 
			initWithFieldLabel:LOCALIZED_STR(labelStringFileKey) 
			andFieldPlaceholder:@"n/a" andScenario:currentScenario 
		andInputVal:boolVal] autorelease];
	BoolFieldEditInfo *enabledFieldEditInfo = 
		[[[BoolFieldEditInfo alloc] initWithFieldInfo:enabledFieldInfo] autorelease];
	[sectionInfo addFieldEditInfo:enabledFieldEditInfo];

}

-(void)populateMultiScenarioGrowthRate:(MultiScenarioGrowthRate*)growthRate
	inSection:(SectionInfo*)sectionInfo
	withLabel:(NSString*)labelStringFileKey
{
	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].currentInputScenario;
	
	SharedEntityVariableValueListMgr *sharedInflationRatesMgr = 
	[[[SharedEntityVariableValueListMgr alloc] initWithEntity:INFLATION_RATE_ENTITY_NAME] autorelease];
	
	NSString *tableSubtitle = [NSString 
			stringWithFormat:LOCALIZED_STR(@"INPUT_INFLATION_RATE__TABLE_SUBTITLE_FORMAT"),
			LOCALIZED_STR(@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE"),
			LOCALIZED_STR(@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE")];

	NSString *valueLabel = LOCALIZED_STR(labelStringFileKey);
	
	VariableValueRuntimeInfo *grRuntimeInfo = [[[VariableValueRuntimeInfo alloc] 
		initWithFormatter:[NumberHelper theHelper].percentFormatter 
		andValueTitle:@"INPUT_INFLATION_RATE_VALUE_TITLE"
		andInlineValueTitleKey:@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE"
		andValueVerb:LOCALIZED_STR(@"INPUT_INFLATION_RATE_ACTION_VERB")
		andPeriodDesc:LOCALIZED_STR(@"INPUT_INFLATION_RATE_PERIOD") 
		andListMgr:sharedInflationRatesMgr
		andSingleValueSubtitleKey:@"INPUT_INFLATION_RATE_SINGLE_VALUE_SECTION_SUBTITLE"
		andVariableValueSubtitleKey:@"SHARED_INTEREST_RATE_DATE_SENSITIVE_VALUE_VARIABLE_SUBTITLE"
		andValuePromptKey:@"INPUT_INFLATION_RATE_VALUE_PROMPT"
		andValueTypeInline:@"inline type TBD"
		andValueTypeTitle:valueLabel
		andValueName:@"Name TBD"
		andTableSubtitle:tableSubtitle] autorelease];


	[sectionInfo addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForScenario:currentScenario andObject:growthRate 
			andKey:MULTI_SCEN_GROWTH_RATE_GROWTH_RATE_KEY 
			andLabel:LOCALIZED_STR(labelStringFileKey) 
		 andValRuntimeInfo:grRuntimeInfo 
		 andDefaultFixedVal:growthRate.defaultFixedGrowthRate]];
 
}



- (void) visitCashFlow:(CashFlowInput *)cashFlow
{

	[self populateInputNameField:cashFlow];
	
 	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].defaultScenario;
	      
    // Amount section
    
    SectionInfo *sectionInfo  = [formPopulator nextSection];
	
	MultiScenarioBoolInputValueFieldInfo *enabledFieldInfo =
		[[[MultiScenarioBoolInputValueFieldInfo alloc] 
			initWithFieldLabel:LOCALIZED_STR(@"INPUT_CASH_FLOW_ENABLED_FIELD_LABEL") 
			andFieldPlaceholder:@"n/a" andScenario:currentScenario 
		andInputVal:cashFlow.multiScenarioCashFlowEnabled] autorelease];
	BoolFieldEditInfo *enabledFieldEditInfo = 
		[[[BoolFieldEditInfo alloc] initWithFieldInfo:enabledFieldInfo] autorelease];
	[sectionInfo addFieldEditInfo:enabledFieldEditInfo];

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
	


    RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = [RepeatFrequencyFieldEditInfo 
		createForScenario:currentScenario andObject:cashFlow 
		andKey:CASH_FLOW_INPUT_MULTI_SCENARIO_EVENT_REPEAT_FREQUENCY_KEY
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_REPEAT_FIELD_LABEL")];
    [sectionInfo addFieldEditInfo:repeatFrequencyInfo];
    
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
	[self populateInputNameField:account];

 	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].defaultScenario;
	
	SectionInfo *sectionInfo = [formPopulator nextSection];

	[sectionInfo addFieldEditInfo:[NumberFieldEditInfo createForObject:account 
             andKey:ACCOUNT_STARTING_BALANCE_KEY 
			 andLabel:LOCALIZED_STR(@"INPUT_SAVINGS_ACCOUNT_STARTING_BALANCE_LABEL")
			 andPlaceholder:LOCALIZED_STR(@"INPUT_ACCOUNT_STARTING_BALANCE_PLACEHOLDER")
			 andNumberFormatter:[NumberHelper theHelper].currencyFormatter]];

	sectionInfo = [formPopulator nextSection];
    sectionInfo.title = 
		LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_AMOUNT_SECTION_TITLE");
		
	MultiScenarioBoolInputValueFieldInfo *enabledFieldInfo =
		[[[MultiScenarioBoolInputValueFieldInfo alloc] 
			initWithFieldLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_ENABLED_LABEL") 
			andFieldPlaceholder:@"n/a" andScenario:currentScenario 
		andInputVal:account.multiScenarioContribEnabled] autorelease];
	BoolFieldEditInfo *enabledFieldEditInfo = 
		[[[BoolFieldEditInfo alloc] initWithFieldInfo:enabledFieldInfo] autorelease];
	[sectionInfo addFieldEditInfo:enabledFieldEditInfo];
	
	
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
			
   RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = [RepeatFrequencyFieldEditInfo 
		createForScenario:currentScenario andObject:account 
		andKey:ACCOUNT_MULTI_SCEN_CONTRIB_REPEAT_FREQUENCY_KEY
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_REPEAT_FIELD_LABEL")];
    [sectionInfo addFieldEditInfo:repeatFrequencyInfo];
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

	MultiScenarioFixedValueFieldInfo *withdrawalPriorityFieldInfo =
		[[[MultiScenarioFixedValueFieldInfo alloc] 
			initWithFieldLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_PRIORITY_LABEL") 
			andFieldPlaceholder:LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_PRIORITY_PLACEHOLDER") 
			andScenario:currentScenario 
		andInputVal:savingsAcct.multiScenarioWithdrawalPriority] autorelease];
   NumberFieldEditInfo *withdrawalPriorityEditInfo = 
		[[NumberFieldEditInfo alloc] initWithFieldInfo:withdrawalPriorityFieldInfo
			andNumberFormatter:[NumberHelper theHelper].decimalFormatter];
	[sectionInfo addFieldEditInfo:withdrawalPriorityEditInfo];
	
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
	[self populateInputNameField:loan];
	
	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].currentInputScenario;

	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_LOAN_COST_SECTION_TITLE");
	
	MultiScenarioBoolInputValueFieldInfo *enabledFieldInfo =
		[[[MultiScenarioBoolInputValueFieldInfo alloc] 
			initWithFieldLabel:LOCALIZED_STR(@"INPUT_LOAN_ENABLED_FIELD_LABEL") 
			andFieldPlaceholder:@"n/a" andScenario:currentScenario 
		andInputVal:loan.multiScenarioLoanEnabled] autorelease];
	BoolFieldEditInfo *enabledFieldEditInfo = 
		[[[BoolFieldEditInfo alloc] initWithFieldInfo:enabledFieldInfo] autorelease];
	[sectionInfo addFieldEditInfo:enabledFieldEditInfo];



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


	MultiScenarioFixedValueFieldInfo *loanDurationFieldInfo =
		[[[MultiScenarioFixedValueFieldInfo alloc] 
			initWithFieldLabel:LOCALIZED_STR(@"INPUT_LOAN_DURATION_LABEL") 
			andFieldPlaceholder:LOCALIZED_STR(@"INPUT_LOAN_DURATION_PLACEHOLDER") 
			andScenario:currentScenario 
		andInputVal:loan.multiScenarioLoanDuration] autorelease];
	DurationFieldEditInfo *loanDurationFieldEditInfo = 
		[[[DurationFieldEditInfo alloc] initWithFieldInfo:loanDurationFieldInfo] autorelease];
	[sectionInfo addFieldEditInfo:loanDurationFieldEditInfo];


	
	[sectionInfo addFieldEditInfo:[NumberFieldEditInfo createForObject:loan 
             andKey:INPUT_LOAN_STARTING_BALANCE_KEY 
			 andLabel:LOCALIZED_STR(@"INPUT_LOAN_STARTING_BALANCE_LABEL")
			 andPlaceholder:LOCALIZED_STR(@"INPUT_LOAN_STARTING_BALANCE_PLACEHOLDER")
			 andNumberFormatter:[NumberHelper theHelper].currencyFormatter]];
			 
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

	MultiScenarioBoolInputValueFieldInfo *enableExtraPmtFieldInfo =
		[[[MultiScenarioBoolInputValueFieldInfo alloc] 
			initWithFieldLabel:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_ENABLED_LABEL") 
			andFieldPlaceholder:@"n/a" andScenario:currentScenario 
		andInputVal:loan.multiScenarioExtraPmtEnabled] autorelease];
	BoolFieldEditInfo *enableExtraPmtFieldEditInfo = 
		[[[BoolFieldEditInfo alloc] initWithFieldInfo:enableExtraPmtFieldInfo] autorelease];
	[sectionInfo addFieldEditInfo:enableExtraPmtFieldEditInfo];
	
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

	MultiScenarioBoolInputValueFieldInfo *enableDownPmtFieldInfo =
		[[[MultiScenarioBoolInputValueFieldInfo alloc] 
			initWithFieldLabel:LOCALIZED_STR(@"INPUT_LOAN_DOWN_PMT_ENABLED_LABEL") 
			andFieldPlaceholder:@"n/a" andScenario:currentScenario 
		andInputVal:loan.multiScenarioDownPmtEnabled] autorelease];
	BoolFieldEditInfo *enableDownPmtFieldEditInfo = 
		[[[BoolFieldEditInfo alloc] initWithFieldInfo:enableDownPmtFieldInfo] autorelease];
	[sectionInfo addFieldEditInfo:enableDownPmtFieldEditInfo];
	
	
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
	[self populateInputNameField:asset];
	
	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].currentInputScenario;

	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_ASSET_VALUE_SECTION_TITLE");
	
	MultiScenarioBoolInputValueFieldInfo *enabledFieldInfo =
		[[[MultiScenarioBoolInputValueFieldInfo alloc] 
			initWithFieldLabel:LOCALIZED_STR(@"INPUT_ASSET_ENABLED_FIELD_LABEL") 
			andFieldPlaceholder:@"n/a" andScenario:currentScenario 
		andInputVal:asset.multiScenarioAssetEnabled] autorelease];
	BoolFieldEditInfo *enabledFieldEditInfo = 
		[[[BoolFieldEditInfo alloc] initWithFieldInfo:enabledFieldInfo] autorelease];
	[sectionInfo addFieldEditInfo:enabledFieldEditInfo];
	
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

	[sectionInfo addFieldEditInfo:[NumberFieldEditInfo createForObject:asset 
             andKey:INPUT_ASSET_STARTING_VALUE_KEY 
			 andLabel:LOCALIZED_STR(@"INPUT_ASSET_STARTING_VALUE_LABEL")
			 andPlaceholder:LOCALIZED_STR(@"INPUT_ASSET_STARTING_VALUE_PLACEHOLDER")
			 andNumberFormatter:[NumberHelper theHelper].currencyFormatter]];

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

 
 	MultiScenarioBoolInputValueFieldInfo *taxableFieldInfo =
		[[[MultiScenarioBoolInputValueFieldInfo alloc] 
			initWithFieldLabel:LOCALIZED_STR(@"INPUT_ASSET_PROCEEDS_TAXABLE_FIELD_LABEL") 
			andFieldPlaceholder:@"n/a" andScenario:currentScenario 
		andInputVal:asset.multiScenarioSaleProceedsTaxable] autorelease];
	BoolFieldEditInfo *taxableFieldEditInfo = 
		[[[BoolFieldEditInfo alloc] initWithFieldInfo:taxableFieldInfo] autorelease];
	[sectionInfo addFieldEditInfo:taxableFieldEditInfo];


}

- (void)visitTax:(TaxInput *)tax
{
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_TAX_TITLE");
	[self populateInputNameField:tax];
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	
	[self populateBoolField:tax.multiScenarioTaxEnabled inSection:sectionInfo 
		withLabel:@"INPUT_TAX_ENABLED_FIELD_LABEL"];
		
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
	[self populateMultiScenarioAmount:tax.exemptionAmt 
		inSection:sectionInfo withValueTitle:@"INPUT_TAX_EXEMPTION_AMOUNT_TITLE"];
	[self populateMultiScenarioGrowthRate:tax.exemptionGrowthRate 
		inSection:sectionInfo withLabel:@"INPUT_TAX_EXEMPTION_GROWTH_RATE_LABEL"];


	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_TAX_DEDUCTION_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"INPUT_TAX_DEDUCTION_SECTION_SUBTITLE");
	[self populateMultiScenarioAmount:tax.stdDeductionAmt inSection:sectionInfo 
		withValueTitle:@"INPUT_TAX_STD_DEDUCTION_TITLE"];
	[self populateMultiScenarioGrowthRate:tax.stdDeductionGrowthRate inSection:sectionInfo withLabel:@"INPUT_TAX_STD_DEDUCTION_GROWTH_RATE_LABEL"];
	
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
