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
#import "RepeatFrequencyFieldEditInfo.h"
#import "DateSensitiveValueFieldEditInfo.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "EventRepeatFrequency.h"
#import "VariableValueRuntimeInfo.h"
#import "SectionInfo.h"
#import "StringValidation.h"
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
#import "StaticNavFieldEditInfo.h"
#import "ItemizedTaxAmtsInfo.h"
#import "TaxBracketFormInfoCreator.h"
#import "PositiveNumberValidator.h"
#import "InputFormPopulator.h"
#import "LimitedAccountWithdrawalsTableViewFactory.h"
#import "MultipleSelectionTableViewControllerFactory.h"
#import "ItemizedTaxAmtsSelectionFormInfoCreator.h"
#import "TableHeaderWithDisclosure.h"
#import "SelectScenarioTableHeaderButtonDelegate.h"
#import "SharedAppValues.h"
#import "Scenario.h"
#import "ItemizedIncomeTaxFormInfoCreator.h"
#import "ItemizedAccountTaxFormInfoCreator.h"
#import "ItemizedLoanTaxFormInfoCreator.h"
#import "ItemizedAssetTaxFormInfoCreator.h"
#import "FormContext.h"
#import "ItemizedExpenseTaxFormInfoCreator.h"
#import "TaxBracket.h"

@implementation DetailInputViewCreator

@synthesize input;
@synthesize isForNewObject;
@synthesize formPopulator;
@synthesize formContext;

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


- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
    self.formPopulator = [[[InputFormPopulator alloc] initForNewObject:self.isForNewObject 
			andFormContext:parentContext] autorelease];
			
	self.formContext = parentContext;
	
	if(!self.isForNewObject)
	{
		formPopulator.formInfo.headerView = [formPopulator 
			scenarioListTableHeaderWithFormContext:parentContext];
	}
    
    [self.input acceptInputVisitor:self];
    
    return formPopulator.formInfo;

}


- (void) visitCashFlow:(CashFlowInput *)cashFlow
{

	[self.formPopulator populateInputNameField:cashFlow];
	
    // Amount section
    
	[formPopulator nextSection];
	[self.formPopulator populateMultiScenBoolField:cashFlow.cashFlowEnabled 
		withLabel:LOCALIZED_STR(@"INPUT_CASH_FLOW_ENABLED_FIELD_LABEL")];

	SectionInfo *sectionInfo   = [formPopulator nextSection];
	sectionInfo.title = 
		LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_SECTION_TITLE");
	
	[self.formPopulator populateMultiScenarioAmount:cashFlow.amount 
		withValueTitle:LOCALIZED_STR(@"INPUT_CASHFLOW_AMOUNT_AMOUNT_FIELD_LABEL")
		andValueName:cashFlow.name];
	
	[self.formPopulator populateMultiScenarioGrowthRate:cashFlow.amountGrowthRate 
		withLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_GROWTH_RATE_FIELD_LABEL") 
		andValueName:cashFlow.name];

    // Occurences section

    sectionInfo = [formPopulator nextSection];
    sectionInfo.title = LOCALIZED_STR(@"INPUT_CASHFLOW_OCCURRENCES_SECTION_TITLE");

	[self.formPopulator populateMultiScenSimDate:cashFlow.startDate 
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_START_FIELD_LABEL") 
		andTitle:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TITLE")
		andTableHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TABLE_HEADER_FORMAT"),[cashFlow inputTypeTitle]] 
		andTableSubHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TABLE_SUBHEADER_FORMAT"),
			[cashFlow inlineInputType],cashFlow.name]];

	RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = 
		[self.formPopulator populateRepeatFrequency:cashFlow.eventRepeatFrequency
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
				andTitle:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TABLE_TITLE")
				andTableHeader:[NSString 
					stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TABLE_HEADER_FORMAT"),
						[cashFlow inputTypeTitle]]
				 andTableSubHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TABLE_SUBHEADER_FORMAT"),[cashFlow inlineInputType],cashFlow.name]
				andNeverEndFieldTitle:LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_LABEL")
				andNeverEndFieldSubtitle:LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_SUBTITLE")
				andNeverEndSectionTitle:LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_SECTION_TITLE")
				andNeverEndHelpInfo:@"neverEndDate"
				andRelEndDateSectionTitle:LOCALIZED_STR(@"SIM_DATE_RELATIVE_ENDING_DATE_SECTION_TITLE") 
				andRelEndDateHelpFile:@"relEndDate"
				andRelEndDateFieldLabel:LOCALIZED_STR(@"RELATIVE_END_DATE_FIELD_LABEL")];
					
        }
        
    }
    
}

- (void)visitExpense:(ExpenseInput*)expense
{    
    formPopulator.formInfo.title = 
	       LOCALIZED_STR(@"INPUT_EXPENSE_VIEW_TITLE");
		   
	[formPopulator nextSection];
	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_EXPENSE_TAX_FIELD_LABEL")
		andFormInfoCreator:[[[ItemizedExpenseTaxFormInfoCreator alloc] initWithExpense:expense
			andIsForNewObject:self.isForNewObject] autorelease]];
}

- (void)visitIncome:(IncomeInput*)income
{
    formPopulator.formInfo.title = 
		LOCALIZED_STR(@"INPUT_INCOME_VIEW_TITLE");
		
	[self.formPopulator nextSection];
	
	[self.formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_INCOME_TAX_FIELD_LABEL")
		andFormInfoCreator:[[[ItemizedIncomeTaxFormInfoCreator alloc] initWithIncome:income 
			andIsForNewObject:self.isForNewObject] autorelease]];	
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
			
	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_INTEREST_SECTION_TITLE")];
	
	[self.formPopulator populateMultiScenarioInvestmentReturnRate:account.interestRate 
		withLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_INTEREST_RATE_FIELD_LABEL")
		andValueName:account.name];
		


	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title =LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWALS_SECTION_TITLE");

	[self.formPopulator populateMultiScenFixedValField:account.withdrawalPriority 
		andValLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_PRIORITY_LABEL") 
		andPrompt:LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_PRIORITY_PLACEHOLDER")
		andValidator:[[[PositiveNumberValidator alloc] init] autorelease]];
	
	DeferredWithdrawalFieldEditInfo *deferredWithdrawalFieldInfo = 
		[[[DeferredWithdrawalFieldEditInfo alloc] 
			initWithDataModelController:self.formContext.dataModelController 
			andAccount:account
			andFieldLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_DEFER_WITHDRAWALS_LABEL")
			andIsNewAccount:self.isForNewObject] autorelease];
	[sectionInfo addFieldEditInfo:deferredWithdrawalFieldInfo];
	
	assert(self.formContext != nil);
	LimitedAccountWithdrawalsTableViewFactory *withdrawalTableViewFactory = 
		[[[LimitedAccountWithdrawalsTableViewFactory alloc] initWithAccount:account] autorelease];
	
	
	NSString *fieldDescription = ([account.limitWithdrawalExpenses count] > 0)?
		LOCALIZED_STR(@"INPUT_ACCOUNT_LIMITED_WITHDRAWALS_FIELD_DESCRIPTION_LIMITED"):
		LOCALIZED_STR(@"INPUT_ACCOUNT_LIMITED_WITHDRAWALS_FIELD_DESCRIPTION_NO_LIMIT");
	StaticNavFieldEditInfo *limitWithdrawalsFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] 
				initWithCaption:LOCALIZED_STR(@"INPUT_ACCOUNT_LIMITED_WITHDRAWALS_FIELD_LABEL")
				andSubtitle:LOCALIZED_STR(@"INPUT_ACCOUNT_LIMITED_WITHDRAWALS_FIELD_SUBTITLE") 
				andContentDescription:fieldDescription
				andSubViewFactory:withdrawalTableViewFactory] autorelease];
	[sectionInfo addFieldEditInfo:limitWithdrawalsFieldEditInfo];		


	sectionInfo = [formPopulator nextSection];
    sectionInfo.title = LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_AMOUNT_SECTION_TITLE");
		
		
	[self.formPopulator populateMultiScenBoolField:account.contribEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_ENABLED_LABEL")];
		
	[self.formPopulator populateMultiScenarioAmount:account.contribAmount withValueTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_AMOUNT_FIELD_LABEL")
		andValueName:account.name];
	  
	[self.formPopulator populateMultiScenarioGrowthRate:account.contribGrowthRate 
		withLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_GROWTH_RATE_FIELD_LABEL")
		andValueName:input.name];
		
	[self.formPopulator populateMultiScenSimDate:account.contribStartDate 
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_START_FIELD_LABEL")  
		andTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_START_DATE_TITLE")
		andTableHeader:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_START_DATE_TABLE_HEADER") 
		andTableSubHeader:[NSString stringWithFormat:
			LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_START_DATE_TABLE_SUBHEADER_FORMAT"),
			[account inlineInputType],account.name]];	

	RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = 
		[self.formPopulator populateRepeatFrequency:account.contribRepeatFrequency
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
			[self.formPopulator populateMultiScenSimEndDate:account.contribEndDate 
				andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_END_FIELD_LABEL") 
				andTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_END_DATE_TABLE_TITLE")
				andTableHeader:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_END_DATE_TABLE_HEADER")
				 andTableSubHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_END_DATE_TABLE_SUBHEADER_FORMAT"),account.name]

				andNeverEndFieldTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_NEVER_END_FIELD_TITLE")
				andNeverEndFieldSubtitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_NEVER_END_FIELD_SUBTITLE")
				andNeverEndSectionTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_NEVER_END_SECTION_TITLE") 
				andNeverEndHelpInfo:@"neverEndDateContrib"
				andRelEndDateSectionTitle:LOCALIZED_STR(@"SIM_DATE_RELATIVE_ENDING_DATE_SECTION_TITLE")
				andRelEndDateHelpFile:@"relEndDateContrib"
				andRelEndDateFieldLabel:LOCALIZED_STR(@"RELATIVE_END_DATE_FIELD_LABEL")];
        }
        
    }
	
	[formPopulator nextSection];
	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_TAXES_FIELD_LABEL")
		andFormInfoCreator:[[[ItemizedAccountTaxFormInfoCreator alloc] initWithAcct:account 
			andIsForNewObject:self.isForNewObject] autorelease]];

}

- (void) visitSavingsAccount:(SavingsAccount *)savingsAcct
{
}

- (void) visitLoan:(LoanInput*)loan
{
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_LOAN_TITLE");
	
	[self.formPopulator populateInputNameField:loan];

	[formPopulator nextSection];
	
	[self.formPopulator populateMultiScenBoolField:loan.loanEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_LOAN_ENABLED_FIELD_LABEL")];
	
	[formPopulator nextSection];
	[self.formPopulator populateCurrencyField:loan andValKey:INPUT_LOAN_STARTING_BALANCE_KEY 
		andLabel:LOCALIZED_STR(@"INPUT_LOAN_STARTING_BALANCE_LABEL") 
		andPlaceholder:LOCALIZED_STR(@"INPUT_LOAN_STARTING_BALANCE_PLACEHOLDER")];


	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LOAN_ORIG_SECTION_TITLE")];
	
	[self.formPopulator populateMultiScenSimDate:loan.origDate 
		andLabel:LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_FIELD_LABEL") 
		andTitle:LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_FIELD_LABEL")
		andTableHeader:LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_TABLE_HEADER") 
		andTableSubHeader:[NSString stringWithFormat:
			LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_SUBHEADER_FORMAT"),loan.name]];

	[self.formPopulator populateMultiScenarioAmount:loan.loanCost 
		withValueTitle:LOCALIZED_STR(@"INPUT_LOAN_LOAN_COST_AMT_FIELD_LABEL")
		andValueName:loan.name];

	[self.formPopulator populateMultiScenarioGrowthRate:loan.loanCostGrowthRate 
		withLabel:LOCALIZED_STR(@"INPUT_LOAN_COST_GROWTH_RATE_FIELD_LABEL")
		andValueName:loan.name];

	[self.formPopulator populateMultiScenarioInterestRate:loan.interestRate 
		withLabel:LOCALIZED_STR(@"INPUT_LOAN_INTEREST_RATE_FIELD_LABEL") 
		andValueName:loan.name];
	  
	
	
	[self.formPopulator populateMultiScenarioDuration:loan.loanDuration 
		andLabel:LOCALIZED_STR(@"INPUT_LOAN_DURATION_LABEL") 
		andPlaceholder:LOCALIZED_STR(@"INPUT_LOAN_DURATION_PLACEHOLDER") ];
		
			 
	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LOAN_DOWN_PMT_SECTION_TITLE")];


	[self.formPopulator populateMultiScenBoolField:loan.downPmtEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_LOAN_DOWN_PMT_ENABLED_LABEL")];
	
	[self.formPopulator populateLoanDownPmtPercent:loan withValueLabel:LOCALIZED_STR(@"INPUT_LOAN_DOWN_PMT_PERCENT_FIELD_LABEL") andValueName:loan.name];

	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_SECTION_TITLE")];

	[self.formPopulator populateMultiScenBoolField:loan.extraPmtEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_ENABLED_LABEL")];
	
	[self.formPopulator populateMultiScenarioAmount:loan.extraPmtAmt 
		withValueTitle:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_AMT_AMOUNT_FIELD_LABEL")
		andValueName:loan.name];
	  
	[self.formPopulator populateMultiScenarioGrowthRate:loan.extraPmtGrowthRate withLabel:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_GROWTH_RATE_FIELD_LABEL")
			andValueName:loan.name];  

		
	[formPopulator nextSection];
	[self.formPopulator populateMultiScenSimEndDate:loan.earlyPayoffDate 
		andLabel:LOCALIZED_STR(@"INPUT_LOAN_EARLY_PAYOFF_FIELD_LABEL") 
		andTitle:LOCALIZED_STR(@"INPUT_LOAN_EARLY_PAYOFF_TITLE")
			andTableHeader:LOCALIZED_STR(@"INPUT_LOAN_EARLY_PAYOFF_TABLE_TITLE")
			andTableSubHeader:[NSString stringWithFormat:
				LOCALIZED_STR(@"INPUT_LOAN_EARLY_PAYOFF_TABLE_SUBTITLE_FORMAT"),loan.name]
				andNeverEndFieldTitle:LOCALIZED_STR(@"INPUT_LOAN_NEVER_PAYOFF_FIELD_TITLE") 
				andNeverEndFieldSubtitle:LOCALIZED_STR(@"INPUT_LOAN_NEVER_PAYOFF_FIELD_SUBTITLE")
				andNeverEndSectionTitle:LOCALIZED_STR(@"INPUT_LOAN_NEVER_PAYOFF_SECTION_TITLE") 
				andNeverEndHelpInfo:@"neverEndDatePayoff"
				andRelEndDateSectionTitle:LOCALIZED_STR(@"INPUT_LOAN_PAYOFF_REL_END_DATE_SECTION_TITLE")
				andRelEndDateHelpFile:@"relEndDatePayoff"
				andRelEndDateFieldLabel:LOCALIZED_STR(@"INPUT_LOAN_PAYOFF_REL_END_DATE_FIELD_LABEL")
				];

	[formPopulator nextSection];
	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_LOAN_TAXES_FIELD_LABEL")
		andFormInfoCreator:[[[ItemizedLoanTaxFormInfoCreator alloc] initWithLoan:loan
		andIsForNewObject:self.isForNewObject] autorelease]];

}

- (void)visitAsset:(AssetInput*)asset
{
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_ASSET_TITLE");
	
	[self.formPopulator populateInputNameField:asset];
	
	[formPopulator nextSection];
	
	[self.formPopulator populateMultiScenBoolField:asset.assetEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_ASSET_ENABLED_FIELD_LABEL")];
	
	
	[formPopulator nextSectionWithTitle:
			LOCALIZED_STR(@"INPUT_ASSET_VALUE_SECTION_TITLE")];

	[self.formPopulator populateCurrencyField:asset andValKey:INPUT_ASSET_STARTING_VALUE_KEY 
		andLabel:LOCALIZED_STR(@"INPUT_ASSET_STARTING_VALUE_LABEL") 
		andPlaceholder:LOCALIZED_STR(@"INPUT_ASSET_STARTING_VALUE_PLACEHOLDER")];

	[self.formPopulator populateMultiScenarioApprecRate:asset.apprecRate 
		withLabel:LOCALIZED_STR(@"INPUT_ASSET_VALUE_APPREC_RATE_FIELD_LABEL")
			andValueName:asset.name];

	
	[formPopulator nextSectionWithTitle:
		LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_SALE_SECTION_TITLE")]; 
 
	[self.formPopulator populateMultiScenSimDate:asset.purchaseDate 
		andLabel:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_FIELD_LABEL") 
		andTitle:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_TITLE")
		andTableHeader:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_TABLE_HEADER")
		 andTableSubHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_TABLE_SUBHEADER_FORMAT"),asset.name]];
		 
	[self.formPopulator populateMultiScenarioAmount:asset.cost 
		withValueTitle:LOCALIZED_STR(@"INPUT_ASSET_COST_FIELD_LABEL")
		andValueName:asset.name];
		
	[self.formPopulator populateMultiScenSimEndDate:asset.saleDate 
		andLabel:LOCALIZED_STR(@"INPUT_ASSET_SALE_DATE_FIELD_LABEL") 
		andTitle:LOCALIZED_STR(@"INPUT_ASSET_SALE_DATE_TITLE")
			andTableHeader:LOCALIZED_STR(@"INPUT_ASSET_SELL_DATE_TABLE_TITLE")
			andTableSubHeader:[NSString stringWithFormat:
				LOCALIZED_STR(@"INPUT_ASSET_SELL_DATE_TABLE_SUBTITLE_FORMAT"),asset.name]
				andNeverEndFieldTitle:LOCALIZED_STR(@"INPUT_ASSET_NEVER_SELL_FIELD_TITLE") 
				andNeverEndFieldSubtitle:LOCALIZED_STR(@"INPUT_ASSET_NEVER_SELL_FIELD_SUBTITLE")
				andNeverEndSectionTitle:LOCALIZED_STR(@"INPUT_ASSET_NEVER_SELL_SECTION_TITLE") 
				andNeverEndHelpInfo:@"neverEndDateSell"
				andRelEndDateSectionTitle:LOCALIZED_STR(@"INPUT_ASSET_SALE_REL_END_DATE_SECTION_TITLE")
				andRelEndDateHelpFile:@"relEndDateSell"
				andRelEndDateFieldLabel:LOCALIZED_STR(@"INPUT_ASSET_SALE_REL_END_DATE_FIELD_LABEL")
				];

 	[formPopulator nextSection];
	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_ASSET_TAXES_FIELD_TITLE")
			andFormInfoCreator:[[[ItemizedAssetTaxFormInfoCreator alloc] initWithAsset:asset
				andIsForNewObject:self.isForNewObject] autorelease]]; 

}

- (void)visitTax:(TaxInput *)tax
{
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_TAX_TITLE");
	[self.formPopulator populateInputNameField:tax];
	
	[formPopulator nextSection];
	
	[self.formPopulator populateMultiScenBoolField:tax.taxEnabled  
		withLabel:LOCALIZED_STR(@"INPUT_TAX_ENABLED_FIELD_LABEL")];
		
	// Tax Bracket Section
	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_TAX_BRACKET_SECTION_TITLE")];
	TaxBracketFormInfoCreator *taxBracketFormInfoCreator =
		[[[TaxBracketFormInfoCreator alloc] initWithTaxBracket:tax.taxBracket] autorelease];
	StaticNavFieldEditInfo *taxRatesFieldEditInfo = [[[StaticNavFieldEditInfo alloc]
		initWithCaption:LOCALIZED_STR(@"INPUT_TAX_RATES_FIELD_LABEL") andSubtitle:nil andContentDescription:nil andSubFormInfoCreator:taxBracketFormInfoCreator] autorelease];
	[formPopulator.currentSection addFieldEditInfo:taxRatesFieldEditInfo];
	
	[formPopulator populateMultiScenarioGrowthRate:tax.taxBracket.cutoffGrowthRate 
		withLabel:LOCALIZED_STR(@"INPUT_TAX_CUTOFF_GROWTH_RATE_FIELD_LABEL")
		 andValueName:LOCALIZED_STR(@"INPUT_TAX_CUTOFF_GROWTH_RATE_VALUE_NAME")];

	
	// TODO Add inflation adjustements for tax rates

		

	// TODO - Double-check how the ItemizedTaxAmtsInfo's specify what is itemized versus the 
	// typical federal and state tax structures.

	// Tax Sources Section

	[formPopulator 
		nextSectionWithTitle:LOCALIZED_STR(@"INPUT_TAX_SOURCES_SECTION_TITLE")
		andHelpFile:@"taxIncomeSources"];
	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_SOURCES_TITLE") 
			andFormInfoCreator:[[[ItemizedTaxAmtsSelectionFormInfoCreator alloc] 
				initWithItemizedTaxAmtsInfo:[ItemizedTaxAmtsInfo taxSourceInfo:tax 
						usingDataModelController:self.formContext.dataModelController]
				andIsForNewObject:self.isForNewObject] autorelease]];		

	// Adjustments Section

	[formPopulator 
		nextSectionWithTitle:LOCALIZED_STR(@"INPUT_TAX_ADJUSTMENT_SECTION_TITLE")
		andHelpFile:@"taxAdjustments"];
	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ADJUSTMENTS_TITLE")
		andFormInfoCreator:[[[ItemizedTaxAmtsSelectionFormInfoCreator alloc] 
			initWithItemizedTaxAmtsInfo:[ItemizedTaxAmtsInfo taxAdjustmentInfo:tax 
						usingDataModelController:self.formContext.dataModelController]
			andIsForNewObject:self.isForNewObject] autorelease]];
	
	// Exemptions Section
	[formPopulator 
		nextSectionWithTitle:LOCALIZED_STR(@"INPUT_TAX_EXEMPTION_SECTION_TITLE")
		andHelpFile:@"taxExemptions"];
	
	[self.formPopulator populateMultiScenarioAmount:tax.exemptionAmt 
		withValueTitle:LOCALIZED_STR(@"INPUT_TAX_EXEMPTION_AMOUNT_TITLE")
		andValueName:tax.name];
		
	
	[self.formPopulator populateMultiScenarioGrowthRate:tax.exemptionGrowthRate 
		withLabel:LOCALIZED_STR(@"INPUT_TAX_EXEMPTION_GROWTH_RATE_LABEL")
			andValueName:tax.name];

	// Deductions Section

	[formPopulator 
		nextSectionWithTitle:LOCALIZED_STR(@"INPUT_TAX_DEDUCTION_SECTION_TITLE")
		andHelpFile:@"taxDeductions"];

	[self.formPopulator populateMultiScenarioAmount:tax.stdDeductionAmt 
		withValueTitle:LOCALIZED_STR(@"INPUT_TAX_STD_DEDUCTION_TITLE")
		andValueName:tax.name];

	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_DEDUCTIONS_TITLE") 
		andFormInfoCreator:[[[ItemizedTaxAmtsSelectionFormInfoCreator alloc] 
			initWithItemizedTaxAmtsInfo:[ItemizedTaxAmtsInfo taxDeductionInfo:tax 
						usingDataModelController:self.formContext.dataModelController]
			andIsForNewObject:self.isForNewObject] autorelease]];	

	[self.formPopulator populateMultiScenarioGrowthRate:tax.stdDeductionGrowthRate  
		withLabel:LOCALIZED_STR(@"INPUT_TAX_STD_DEDUCTION_GROWTH_RATE_LABEL")
		andValueName:tax.name];

	// Tax Credits Section
		
	[formPopulator 
		nextSectionWithTitle:LOCALIZED_STR(@"INPUT_TAX_CREDITS_SECTION_TITLE")
		andHelpFile:@"taxCredits"];
	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_CREDITS_TITLE")
		andFormInfoCreator:[[[ItemizedTaxAmtsSelectionFormInfoCreator alloc]
		initWithItemizedTaxAmtsInfo:[ItemizedTaxAmtsInfo taxCreditInfo:tax 
						usingDataModelController:self.formContext.dataModelController]
			andIsForNewObject:self.isForNewObject] autorelease]];	
	

}


- (void)dealloc
{
    [formPopulator release];
	[formContext release];
    [super dealloc];
}


@end
