//
//  DetailInputViewCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// TODO - Prune this import list, based upon
// the consolidation of view population using the 
// populator object.
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
#import "MultiScenarioFixedValueFieldInfo.h"
#import "LoanInput.h"
#import "LoanDownPmtPercent.h"
#import "AssetInput.h"
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
	
    // Amount section
    
    SectionInfo *sectionInfo  = [formPopulator nextSection];
	
	
	[self.formPopulator populateMultiScenBoolField:cashFlow.cashFlowEnabled withLabel:LOCALIZED_STR(@"INPUT_CASH_FLOW_ENABLED_FIELD_LABEL")];

    sectionInfo.title = 
		LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_SECTION_TITLE");
	
	[self.formPopulator populateMultiScenarioAmount:cashFlow.amount 
		withValueTitle:LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_AMOUNT_FIELD_LABEL")];
	
	[self.formPopulator populateMultiScenarioGrowthRate:cashFlow.amountGrowthRate 
		withLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_GROWTH_RATE_FIELD_LABEL")];

    // Occurences section

    sectionInfo = [formPopulator nextSection];
    sectionInfo.title = LOCALIZED_STR(@"INPUT_CASHFLOW_OCCURRENCES_SECTION_TITLE");

	[self.formPopulator populateMultiScenSimDate:cashFlow.startDate 
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_START_FIELD_LABEL") 
		andTitle:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TITLE")];

	RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = 
		[self.formPopulator populateRepeatFrequency:cashFlow
		andFreqKey:CASH_FLOW_INPUT_EVENT_REPEAT_FREQUENCY_KEY 
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
		
			[self.formPopulator populateMultiScenSimEndDate:cashFlow.endDate 
				andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_END_FIELD_LABEL") 
				andTitle:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TITLE")];
					
        }
        
    }
    
}

- (void)visitExpense:(ExpenseInput*)expense
{    
    formPopulator.formInfo.title = 
	       LOCALIZED_STR(@"INPUT_EXPENSE_VIEW_TITLE");
	   
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
	
	 [formPopulator nextSection];

	[self.formPopulator populateCurrencyField:account andValKey:ACCOUNT_STARTING_BALANCE_KEY
		andLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_STARTING_BALANCE_LABEL") 
			andPlaceholder:LOCALIZED_STR(@"INPUT_ACCOUNT_STARTING_BALANCE_PLACEHOLDER")];

	SectionInfo *sectionInfo = [formPopulator nextSection];
    sectionInfo.title = LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_AMOUNT_SECTION_TITLE");
		
		
	[self.formPopulator populateMultiScenBoolField:account.contribEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_ENABLED_LABEL")];
		
	[self.formPopulator populateMultiScenarioAmount:account.contribAmount withValueTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_AMOUNT_FIELD_LABEL")];
	  
	[self.formPopulator populateMultiScenarioGrowthRate:account.contribGrowthRate 
		withLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_GROWTH_RATE_FIELD_LABEL")];
		
	[self.formPopulator populateMultiScenSimDate:account.contribStartDate 
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_START_FIELD_LABEL")  
		andTitle:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TITLE")];	

	RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = 
		[self.formPopulator populateRepeatFrequency:account
		andFreqKey:ACCOUNT_MULTI_SCEN_CONTRIB_REPEAT_FREQUENCY_KEY 
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_REPEAT_FIELD_LABEL")];
		
		
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title =LOCALIZED_STR(@"INPUT_ACCOUNT_INTEREST_SECTION_TITLE");
	
	[self.formPopulator populateMultiScenarioGrowthRate:account.interestRate 
		withLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_INTEREST_RATE_FIELD_LABEL")];


	sectionInfo = [formPopulator nextSection];
	sectionInfo.title =LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWALS_SECTION_TITLE");

	[self.formPopulator populateMultiScenFixedValField:account.withdrawalPriority 
		andValLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_PRIORITY_LABEL") 
		andPrompt:LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_PRIORITY_PLACEHOLDER")];
	
	DeferredWithdrawalFieldEditInfo *deferredWithdrawalFieldInfo = 
		[[[DeferredWithdrawalFieldEditInfo alloc] initWithAccount:account
			andFieldLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_DEFER_WITHDRAWALS_LABEL")
			andIsNewAccount:self.isForNewObject] autorelease];
	[sectionInfo addFieldEditInfo:deferredWithdrawalFieldInfo];
	

    
    // Only display (and prompt for) and end date when/if the repeat frequency is set to something other
    // than "Once", such that an end date is needed. TBD - Should the end date in this case default to 
    // "Plan end date".
	if([repeatFrequencyInfo.fieldInfo fieldIsInitializedInParentObject])	
    {
        EventRepeatFrequency *repeatFreq = (EventRepeatFrequency*)[repeatFrequencyInfo.fieldInfo getFieldValue];
        assert(repeatFreq != nil);
        if([repeatFreq  eventRepeatsMoreThanOnce])
        {
			[self.formPopulator populateMultiScenSimEndDate:account.contribEndDate 
				andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_END_FIELD_LABEL") 
				andTitle:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TITLE")];
        }
        
    }

}

- (void) visitSavingsAccount:(SavingsAccount *)savingsAcct
{
}

- (void) visitLoan:(LoanInput*)loan
{
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_LOAN_TITLE");
	[self.formPopulator populateInputNameField:loan];
	
	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].currentInputScenario;

	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_LOAN_COST_SECTION_TITLE");
	
	
	[self.formPopulator populateMultiScenBoolField:loan.loanEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_LOAN_ENABLED_FIELD_LABEL")];

	[self.formPopulator populateMultiScenarioAmount:loan.loanCost 
		withValueTitle:LOCALIZED_STR(@"INPUT_LOAN_LOAN_COST_AMT_FIELD_LABEL")];

	[self.formPopulator populateMultiScenarioGrowthRate:loan.loanCostGrowthRate withLabel:LOCALIZED_STR(@"INPUT_LOAN_COST_GROWTH_RATE_FIELD_LABEL")];
	  
	
	[self.formPopulator populateMultiScenSimDate:loan.origDate 
		andLabel:LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_FIELD_LABEL") 
		andTitle:LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_FIELD_LABEL")];
	
	[self.formPopulator populateMultiScenarioDuration:loan.loanDuration 
		andLabel:LOCALIZED_STR(@"INPUT_LOAN_DURATION_LABEL") 
		andPlaceholder:LOCALIZED_STR(@"INPUT_LOAN_DURATION_PLACEHOLDER") ];

	
	[self.formPopulator populateCurrencyField:loan andValKey:INPUT_LOAN_STARTING_BALANCE_KEY 
		andLabel:LOCALIZED_STR(@"INPUT_LOAN_STARTING_BALANCE_LABEL") 
		andPlaceholder:LOCALIZED_STR(@"INPUT_LOAN_STARTING_BALANCE_PLACEHOLDER")];
			 
	sectionInfo = [formPopulator nextSection]; 
	sectionInfo.title = LOCALIZED_STR(@"INPUT_LOAN_INTEREST_SECTION_TITLE");
	
	
	[self.formPopulator populateMultiScenarioGrowthRate:loan.interestRate 
		withLabel:LOCALIZED_STR(@"INPUT_LOAN_INTEREST_RATE_FIELD_LABEL") ];
	

	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_SECTION_TITLE");


	[self.formPopulator populateMultiScenBoolField:loan.extraPmtEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_ENABLED_LABEL")];
	
	[self.formPopulator populateMultiScenarioAmount:loan.extraPmtAmt 
		withValueTitle:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_AMT_AMOUNT_FIELD_LABEL")];
	  
	[self.formPopulator populateMultiScenarioGrowthRate:loan.extraPmtGrowthRate withLabel:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_GROWTH_RATE_FIELD_LABEL")];  

		
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_LOAN_DOWN_PMT_SECTION_TITLE");


	[self.formPopulator populateMultiScenBoolField:loan.downPmtEnabled 
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
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_ASSET_VALUE_SECTION_TITLE");
	
	
	[self.formPopulator populateMultiScenBoolField:asset.assetEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_ASSET_ENABLED_FIELD_LABEL")];
	
	[self.formPopulator populateMultiScenarioAmount:asset.cost 
		withValueTitle:LOCALIZED_STR(@"INPUT_ASSET_COST_FIELD_LABEL")];
	

	[self.formPopulator populateCurrencyField:asset andValKey:INPUT_ASSET_STARTING_VALUE_KEY 
		andLabel:LOCALIZED_STR(@"INPUT_ASSET_STARTING_VALUE_LABEL") 
		andPlaceholder:LOCALIZED_STR(@"INPUT_ASSET_STARTING_VALUE_PLACEHOLDER")];

	[self.formPopulator populateMultiScenarioGrowthRate:asset.apprecRate 
		withLabel:LOCALIZED_STR(@"INPUT_ASSET_VALUE_APPREC_RATE_FIELD_LABEL")];
 
 
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_SALE_SECTION_TITLE");
 
 
	[self.formPopulator populateMultiScenSimDate:asset.purchaseDate 
		andLabel:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_FIELD_LABEL") 
		andTitle:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_TITLE")];

	[self.formPopulator populateMultiScenSimEndDate:asset.saleDate 
		andLabel:LOCALIZED_STR(@"INPUT_ASSET_SALE_DATE_FIELD_LABEL") 
		andTitle:LOCALIZED_STR(@"INPUT_ASSET_SALE_DATE_TITLE")];

}

- (void)visitTax:(TaxInput *)tax
{
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_TAX_TITLE");
	[self.formPopulator populateInputNameField:tax];
	
	[formPopulator nextSection];
	
	[self.formPopulator populateMultiScenBoolField:tax.taxEnabled  
		withLabel:LOCALIZED_STR(@"INPUT_TAX_ENABLED_FIELD_LABEL")];
		
	SectionInfo *sectionInfo = [formPopulator nextSection];
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
