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
#import "TransferInput.h"
#import "TransferEndpointFieldEditInfo.h"
#import "MultiScenarioSimDate.h"
#import "SimInputHelper.h"
#import "DateHelper.h"
#import "MultiScenarioInputValue.h"
#import "InputTagsFieldEditInfo.h"
#import "ItemizedAssetLossTaxFormInfoCreator.h"
#import "BoolFieldCell.h"
#import "BoolFieldShowHideCondition.h"

@implementation DetailInputViewCreator

@synthesize input;
@synthesize isForNewObject;
@synthesize formPopulator;
@synthesize formContext;
@synthesize dateHelper;

- (void)dealloc
{
    [formPopulator release];
	[formContext release];
    [dateHelper release];
    
    [super dealloc];
}


-(id) initWithInput:(Input*)theInput andIsForNewObject:(BOOL)forNewObject
{
    self = [super init];
    if(self)
    {
        assert(theInput!=nil);
        self.input = theInput;
		
		self.isForNewObject = forNewObject;
        self.dateHelper = [[[DateHelper alloc] init] autorelease];
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

-(void)populateCommonCashFlowFields:(CashFlowInput *)cashFlow
	withAmountTaxFieldEditInfo:(StaticNavFieldEditInfo*)amountTaxFieldEditInfo
{
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
		
	if(amountTaxFieldEditInfo != nil)
	{
		[self.formPopulator.currentSection addFieldEditInfo:amountTaxFieldEditInfo];
	}

    // Occurences section

    sectionInfo = [formPopulator nextSection];
    sectionInfo.title = LOCALIZED_STR(@"INPUT_CASHFLOW_OCCURRENCES_SECTION_TITLE");
	
	NSString *startDateSubHeader = [StringValidation nonEmptyString:cashFlow.name]?
		[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TABLE_SUBHEADER_FORMAT"),
			[cashFlow inlineInputType],cashFlow.name]:
		[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TABLE_SUBHEADER_FORMAT_NO_NAME"),
			[cashFlow inlineInputType]];

	[self.formPopulator populateMultiScenSimDate:cashFlow.startDate 
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_START_FIELD_LABEL") 
		andTitle:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TITLE")
		andTableHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TABLE_HEADER_FORMAT"),[cashFlow inputTypeTitle]] 
		andTableSubHeader:startDateSubHeader];

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
			NSString *endDateSubtitle = [StringValidation nonEmptyString:cashFlow.name]?
				[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TABLE_SUBHEADER_FORMAT"),
					[cashFlow inlineInputType],cashFlow.name]:
				[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TABLE_SUBHEADER_FORMAT_NO_NAME"),
					[cashFlow inlineInputType]];
		
			[self.formPopulator populateMultiScenSimEndDate:cashFlow.endDate 
				andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_END_FIELD_LABEL") 
				andTitle:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TABLE_TITLE")
				andTableHeader:[NSString 
					stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_END_DATE_TABLE_HEADER_FORMAT"),
						[cashFlow inputTypeTitle]]
				 andTableSubHeader:endDateSubtitle
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


- (void) visitCashFlow:(CashFlowInput *)cashFlow
{
	// no-op - population occurs when visiting subclasses
}

- (void)visitExpense:(ExpenseInput*)expense
{

   formPopulator.formInfo.title = 
	       LOCALIZED_STR(@"INPUT_EXPENSE_VIEW_TITLE");

	NSArray *iconNames = [NSArray arrayWithObjects:
	
		// Business/Income Related
		@"input-icon-expense.png",
		@"input-icon-briefcase.png",
		
		// Home & Auto
		@"input-icon-home.png",
		@"input-icon-apartment.png",
		@"input-icon-car.png",
		@"input-icon-fuel.png",
		
		// Medical
		@"input-icon-medical.png",
		@"input-icon-medicine.png",
		@"input-icon-dental.png",
		@"input-icon-cat.png",
		@"input-icon-dogpaw.png",

		// Services
		@"input-icon-cellphone.png",
		@"input-icon-internet.png",
		@"input-icon-hair.png",
		@"input-icon-lightbulb.png",
		@"input-icon-water.png",
		@"input-icon-trash.png",
		@"input-icon-broom.png",
		@"input-icon-lock.png",
		@"input-logo-lawn.png",
		
		
		// Discretionary Expenses
		@"input-icon-tv.png",
		@"input-icon-camera.png",
		@"input-icon-shopping.png",
		@"input-icon-clothes.png",

		@"input-icon-college.png",
		@"input-icon-book.png",
		@"input-icon-church.png",
		@"input-icon-dining.png",
		@"input-icon-coffee.png",		
		@"input-icon-golf.png",
		@"input-icon-tennis.png",
		@"input-icon-music.png",
		@"input-icon-computer.png",
		@"input-icon-wedding.png",
		@"input-logo-gift.png",
		
		// Travel and Leisure
		@"input-icon-vacation.png",
		@"input-icon-airplane.png",
		@"input-icon-boat.png",
				
		// Assets/Accounts
		@"input-icon-money.png",
		@"input-icon-moneybag.png",
		@"input-icon-piggybank.png",
		@"input-icon-invest.png",
		@"input-icon-candlestick.png",		
		
		nil];


	[self.formPopulator populateInputNameField:expense withIconList:iconNames];
	[self.formPopulator populateNoteFieldInParentObj:expense
		withNameField:INPUT_NOTES_KEY
		andFieldTitle:LOCALIZED_STR(@"INPUT_NOTE_FIELD_TITLE")
		andPlaceholder:LOCALIZED_STR(@"INPUT_NOTE_FIELD_PLACEHOLDER")];
	[self.formPopulator.currentSection addFieldEditInfo:
			[[[InputTagsFieldEditInfo alloc] initWithInput:expense] autorelease]];
	
	StaticNavFieldEditInfo *amountTaxFieldEditInfo = [formPopulator createItemizedTaxSelectionFieldEditInfoWithFieldLabel:LOCALIZED_STR(@"INPUT_EXPENSE_TAX_FIELD_LABEL")
		andFormInfoCreator:[[[ItemizedExpenseTaxFormInfoCreator alloc] initWithExpense:expense
			andIsForNewObject:self.isForNewObject] autorelease]
			andItemizedTaxAmtsInfo:expense.expenseItemizedTaxAmts];

	
	[self populateCommonCashFlowFields:expense withAmountTaxFieldEditInfo:amountTaxFieldEditInfo];

}

- (void)visitIncome:(IncomeInput*)income
{

    formPopulator.formInfo.title = 
		LOCALIZED_STR(@"INPUT_INCOME_VIEW_TITLE");


	NSArray *iconNames = [NSArray arrayWithObjects:
	
		// Business/Income Related
		@"input-icon-income.png",
		@"input-icon-briefcase.png",
		
		// Assets/Accounts
		@"input-icon-money.png",
		
		nil];


	[self.formPopulator populateInputNameField:income withIconList:iconNames];
	[self.formPopulator populateNoteFieldInParentObj:income
		withNameField:INPUT_NOTES_KEY
		andFieldTitle:LOCALIZED_STR(@"INPUT_NOTE_FIELD_TITLE")
		andPlaceholder:LOCALIZED_STR(@"INPUT_NOTE_FIELD_PLACEHOLDER")];
	[self.formPopulator.currentSection addFieldEditInfo:
			[[[InputTagsFieldEditInfo alloc] initWithInput:income] autorelease]];

	StaticNavFieldEditInfo *amountTaxFieldEditInfo = [self.formPopulator createItemizedTaxSelectionFieldEditInfoWithFieldLabel:LOCALIZED_STR(@"INPUT_INCOME_TAX_FIELD_LABEL")
		andFormInfoCreator:[[[ItemizedIncomeTaxFormInfoCreator alloc] initWithIncome:income 
			andIsForNewObject:self.isForNewObject] autorelease]
			andItemizedTaxAmtsInfo:income.incomeItemizedTaxAmts];


	[self populateCommonCashFlowFields:income withAmountTaxFieldEditInfo:amountTaxFieldEditInfo];
}

- (void)visitTransfer:(TransferInput *)transfer
{
    formPopulator.formInfo.title =
	       LOCALIZED_STR(@"INPUT_TRANSFER_VIEW_TITLE");

	NSArray *iconNames = [NSArray arrayWithObjects:
	
		// Assets/Accounts
		@"input-icon-transfer.png",

		nil];
		  
	[self.formPopulator populateInputNameField:transfer withIconList:iconNames];
	[self.formPopulator populateNoteFieldInParentObj:transfer
		withNameField:INPUT_NOTES_KEY
		andFieldTitle:LOCALIZED_STR(@"INPUT_NOTE_FIELD_TITLE")
		andPlaceholder:LOCALIZED_STR(@"INPUT_NOTE_FIELD_PLACEHOLDER")];
	[self.formPopulator.currentSection addFieldEditInfo:
			[[[InputTagsFieldEditInfo alloc] initWithInput:transfer] autorelease]];
		  
	[self.formPopulator nextSection];
	
	ManagedObjectFieldInfo *fromEndpointFieldInfo = [[[ManagedObjectFieldInfo alloc] 
		initWithManagedObject:transfer 
		andFieldKey:TRANSFER_INPUT_FROM_ENDPOINT_KEY 
		andFieldLabel:LOCALIZED_STR(@"INPUT_TRANSFER_FROM_FIELD_LABEL")
		andFieldPlaceholder:LOCALIZED_STR(@"INPUT_TRANSFER_FROM_PROMPT")] autorelease];
	TransferEndpointFieldEditInfo *fromEndpointFieldEditInfo = [[[TransferEndpointFieldEditInfo alloc]
		initWithManagedObjFieldInfo:fromEndpointFieldInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:fromEndpointFieldEditInfo];
	
	ManagedObjectFieldInfo *toEndpointFieldInfo = [[[ManagedObjectFieldInfo alloc] 
		initWithManagedObject:transfer 
		andFieldKey:TRANSFER_INPUT_TO_ENDPOINT_KEY 
		andFieldLabel:LOCALIZED_STR(@"INPUT_TRANSFER_TO_FIELD_LABEL")
		andFieldPlaceholder:LOCALIZED_STR(@"INPUT_TRANSFER_TO_PROMPT")] autorelease];
	TransferEndpointFieldEditInfo *toEndpointFieldEditInfo = [[[TransferEndpointFieldEditInfo alloc]
		initWithManagedObjFieldInfo:toEndpointFieldInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:toEndpointFieldEditInfo];
	
		  		  
	[self populateCommonCashFlowFields:transfer withAmountTaxFieldEditInfo:nil];
		  
				   	   
}



- (void) visitAccount:(Account*)account
{
    formPopulator.formInfo.title = 
		LOCALIZED_STR(@"INPUT_ACCOUNT_TITLE");
		
		
	NSArray *iconNames = [NSArray arrayWithObjects:
			
		// Assets/Accounts
		@"input-icon-piggybank.png",
		@"input-icon-money.png",
		@"input-icon-invest.png",
		@"input-icon-candlestick.png",		
		
		nil];		
		
	[self.formPopulator populateInputNameField:account withIconList:iconNames];
	[self.formPopulator populateNoteFieldInParentObj:account
		withNameField:INPUT_NOTES_KEY
		andFieldTitle:LOCALIZED_STR(@"INPUT_NOTE_FIELD_TITLE")
		andPlaceholder:LOCALIZED_STR(@"INPUT_NOTE_FIELD_PLACEHOLDER")];
	[self.formPopulator.currentSection addFieldEditInfo:
			[[[InputTagsFieldEditInfo alloc] initWithInput:account] autorelease]];
	
	 [formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_BALANCE_SECTION_TITLE")
		andHelpFile:@"account" andAnchorWithinHelpFile:@"current-account-balances"];

	[self.formPopulator populateCurrencyField:account andValKey:ACCOUNT_STARTING_BALANCE_KEY
		andLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_STARTING_BALANCE_LABEL")
			andPlaceholder:LOCALIZED_STR(@"INPUT_ACCOUNT_STARTING_BALANCE_PLACEHOLDER")];
	[self.formPopulator populateCurrencyField:account andValKey:ACCOUNT_COST_BASIS_KEY andLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_COST_BASIS_LABEL")
		andPlaceholder:LOCALIZED_STR(@"INPUT_ACCOUNT_COST_BASIS_PLACEHOLDER")
		andSubtitle:LOCALIZED_STR(@"INPUT_ACCOUNT_COST_BASIS_FIELD_SUBTITLE")];
	
	if(TRUE)
	{
		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_INTEREST_SECTION_TITLE")];
		[self.formPopulator populateMultiScenarioInvestmentReturnRate:account.interestRate
			withLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_INTEREST_RATE_FIELD_LABEL")
			andValueName:account.name];
			
		ItemizedAccountTaxFormInfoCreator *acctTaxFormInfoCreator =
				[[[ItemizedAccountTaxFormInfoCreator alloc] initWithAcct:account
				andIsForNewObject:self.isForNewObject] autorelease];
		acctTaxFormInfoCreator.showInterest = TRUE;
		[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_INTEREST_TAXES_FIELD_LABEL")
			andFormInfoCreator:acctTaxFormInfoCreator
			andItemizedTaxAmtsInfo:account.accountInterestItemizedTaxAmt];
			
		ItemizedAccountTaxFormInfoCreator *acctCapGainTaxFormInfoCreator =
				[[[ItemizedAccountTaxFormInfoCreator alloc] initWithAcct:account
				andIsForNewObject:self.isForNewObject] autorelease];
		acctCapGainTaxFormInfoCreator.showCapGain = TRUE;
		[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_CAP_GAINS_TAXES_FIELD_LABEL")
			andFormInfoCreator:acctCapGainTaxFormInfoCreator
			andItemizedTaxAmtsInfo:account.accountDividendItemizedTaxAmt];
	
		ItemizedAccountTaxFormInfoCreator *acctCapLossTaxFormInfoCreator =
				[[[ItemizedAccountTaxFormInfoCreator alloc] initWithAcct:account
				andIsForNewObject:self.isForNewObject] autorelease];
		acctCapLossTaxFormInfoCreator.showCapLoss = TRUE;
		[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_CAP_LOSS_TAXES_FIELD_LABEL")
			andFormInfoCreator:acctCapLossTaxFormInfoCreator
			andItemizedTaxAmtsInfo:account.accountDividendItemizedTaxAmt];
	}
		
	if(TRUE)
	{
		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_DIVIDEND_SECTION_TITLE")
				andHelpFile:@"account" andAnchorWithinHelpFile:@"dividends"];
				
		BoolFieldShowHideCondition *showHideAcctDividend =
			[self.formPopulator
				populateConditionalFieldVisibilityMultiScenBoolField:account.dividendEnabled withLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_DIVIDEND_ENABLED_LABEL")];
								
		[self.formPopulator populateMultiScenarioDividendReturnRate:account.dividendRate
			withLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_DIVIDEND_RATE_FIELD_LABEL")
			andValueName:account.name andShowHideCondition:showHideAcctDividend];
		ItemizedAccountTaxFormInfoCreator *acctDividendTaxFormInfoCreator =
				[[[ItemizedAccountTaxFormInfoCreator alloc] initWithAcct:account
				andIsForNewObject:self.isForNewObject] autorelease];
		acctDividendTaxFormInfoCreator.showDividend = TRUE;
		[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_DIVIDENDS_TAXES_FIELD_LABEL")
			andFormInfoCreator:acctDividendTaxFormInfoCreator
			andItemizedTaxAmtsInfo:account.accountDividendItemizedTaxAmt
			andShowHideCondition:showHideAcctDividend];
			
		[self.formPopulator populateMultiScenarioDividendReinvestPercent:account.dividendReinvestPercent
			withLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_DIVIDED_REINVESTMENT_PERCENT_FIELD_LABEL")
			andValueName:account.name andShowHideCondition:showHideAcctDividend];
	
	}
		
	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title =LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWALS_SECTION_TITLE");
	
	[self.formPopulator populateAcctWithdrawalOrderField:account
		andFieldCaption:LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_PRIORITY_LABEL")
		andFieldSubtitle:LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_PRIORITY_SUBTITLE")];
		
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


	ItemizedAccountTaxFormInfoCreator *acctWithdTaxFormInfoCreator =
			[[[ItemizedAccountTaxFormInfoCreator alloc] initWithAcct:account
			andIsForNewObject:self.isForNewObject] autorelease];
	acctWithdTaxFormInfoCreator.showWithdrawal = TRUE;
	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_TAXES_FIELD_LABEL")
		andFormInfoCreator:acctWithdTaxFormInfoCreator andItemizedTaxAmtsInfo:account.accountWithdrawalItemizedTaxAmt];

	if(TRUE)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_AMOUNT_SECTION_TITLE");
			
		BoolFieldShowHideCondition *showHideAcctContribCondition =
			[self.formPopulator
				populateConditionalFieldVisibilityMultiScenBoolField:account.contribEnabled withLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_ENABLED_LABEL")];

		[self.formPopulator populateMultiScenarioAmount:account.contribAmount withValueTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_AMOUNT_FIELD_LABEL")
			andValueName:account.name withShowHideCondition:showHideAcctContribCondition];
		  
		[self.formPopulator populateMultiScenarioGrowthRate:account.contribGrowthRate 
			withLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_GROWTH_RATE_FIELD_LABEL")
			andValueName:input.name withShowHideCondition:showHideAcctContribCondition];
			
		NSString *contribStartDateSubheader = [StringValidation nonEmptyString:account.name]?
			[NSString stringWithFormat:
				LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_START_DATE_TABLE_SUBHEADER_FORMAT"),
				[account inlineInputType],account.name]:
			[NSString stringWithFormat:
				LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_START_DATE_TABLE_SUBHEADER_FORMAT_NO_NAME"),
				[account inlineInputType]];
		
		[self.formPopulator populateMultiScenSimDate:account.contribStartDate 
			andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_START_FIELD_LABEL")  
			andTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_START_DATE_TITLE")
			andTableHeader:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_START_DATE_TABLE_HEADER") 
			andTableSubHeader:contribStartDateSubheader
			andShowHideCondition:showHideAcctContribCondition];

		RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = 
			[self.formPopulator populateRepeatFrequency:account.contribRepeatFrequency
				andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_REPEAT_FIELD_LABEL")
				andShowHideCondition:showHideAcctContribCondition];
	 
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
					andRelEndDateFieldLabel:LOCALIZED_STR(@"RELATIVE_END_DATE_FIELD_LABEL")
					andShowHideCondition:showHideAcctContribCondition];
			}
			
		}

		ItemizedAccountTaxFormInfoCreator *acctContribTaxFormInfoCreator =
				[[[ItemizedAccountTaxFormInfoCreator alloc] initWithAcct:account
				andIsForNewObject:self.isForNewObject] autorelease];
		acctContribTaxFormInfoCreator.showContributions = TRUE;
		[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_TAXES_FIELD_LABEL")
			andFormInfoCreator:acctContribTaxFormInfoCreator andItemizedTaxAmtsInfo:account.accountContribItemizedTaxAmt
			andShowHideCondition:showHideAcctContribCondition];
	}

}

- (void) visitSavingsAccount:(SavingsAccount *)savingsAcct
{
}

- (void) visitLoan:(LoanInput*)loan
{
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_LOAN_TITLE");
	
		NSArray *iconNames = [NSArray arrayWithObjects:
			@"input-icon-loan.png",

			// Home & Auto
			@"input-icon-loan-home.png",
			@"input-icon-loan-car.png",
						
			// Discretionary Expenses
			@"input-icon-loan-college.png",
			@"input-icon-loan-business.png",
		nil];
	
	[self.formPopulator populateInputNameField:loan withIconList:iconNames];
	[self.formPopulator populateNoteFieldInParentObj:loan
		withNameField:INPUT_NOTES_KEY
		andFieldTitle:LOCALIZED_STR(@"INPUT_NOTE_FIELD_TITLE")
		andPlaceholder:LOCALIZED_STR(@"INPUT_NOTE_FIELD_PLACEHOLDER")];
	[self.formPopulator.currentSection addFieldEditInfo:
			[[[InputTagsFieldEditInfo alloc] initWithInput:loan] autorelease]];

	[formPopulator nextSection];
	
	[self.formPopulator populateMultiScenBoolField:loan.loanEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_LOAN_ENABLED_FIELD_LABEL")
			andSubtitle:LOCALIZED_STR(@"INPUT_LOAN_ENABLED_FIELD_SUBTITLE")];
	
    // Only show the starting/outstanding balance if the loan originates
    // in the past. A starting balance for a future loan doesn't make
	// sense, so it would only be confusing to show this to the user.
    if([loan originationDateDefinedAndInThePastForScenario:formPopulator.inputScenario usingDateHelper:self.dateHelper])
    {
        [formPopulator nextSection];
        [self.formPopulator populateCurrencyField:loan andValKey:INPUT_LOAN_STARTING_BALANCE_KEY
                andLabel:LOCALIZED_STR(@"INPUT_LOAN_STARTING_BALANCE_LABEL")
				andPlaceholder:LOCALIZED_STR(@"INPUT_LOAN_STARTING_BALANCE_PLACEHOLDER")
				andSubtitle:LOCALIZED_STR(@"INPUT_LOAN_STARTING_BALANCE_SUBTITLE")];
	}

	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LOAN_ORIG_SECTION_TITLE")
        andHelpFile:@"loan" andAnchorWithinHelpFile:@"loan-origination"];
	
	NSString *loanOrigDateSubtitle = [StringValidation nonEmptyString:loan.name]?
		[NSString stringWithFormat:
			LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_SUBHEADER_FORMAT"),loan.name]:
			LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_SUBHEADER_FORMAT_NO_NAME");
	
	[self.formPopulator populateMultiScenSimDate:loan.origDate 
		andLabel:LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_FIELD_LABEL") 
		andTitle:LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_FIELD_LABEL")
		andTableHeader:LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_TABLE_HEADER") 
		andTableSubHeader:loanOrigDateSubtitle];

	[self.formPopulator populateMultiScenarioLoanOrigAmount:loan.loanCost
		withValueTitle:LOCALIZED_STR(@"INPUT_LOAN_LOAN_COST_AMT_FIELD_LABEL")
		andValueName:loan.name];

    // Only show the loan cost (amount borrowed) growth rate if the
    // loan originates in the future. To show this value when it is not applicable
    // will cause unnecessary confusion. The loanCostGrowthRate field is initialized
    // with a default growth rate, so there is no conflict to not showing this value.
    if([loan originationDateDefinedAndInTheFutureForScenario:formPopulator.inputScenario usingDateHelper:self.dateHelper])
    {
        [self.formPopulator populateMultiScenarioGrowthRate:loan.loanCostGrowthRate
              withLabel:LOCALIZED_STR(@"INPUT_LOAN_COST_GROWTH_RATE_FIELD_LABEL")
              andValueName:loan.name];        
    }


	[self.formPopulator populateMultiScenarioDuration:loan.loanDuration 
		andLabel:LOCALIZED_STR(@"INPUT_LOAN_DURATION_LABEL") 
		andPlaceholder:LOCALIZED_STR(@"INPUT_LOAN_DURATION_PLACEHOLDER") ];
		
	[self.formPopulator populateMultiScenarioInterestRate:loan.interestRate 
		withLabel:LOCALIZED_STR(@"INPUT_LOAN_INTEREST_RATE_FIELD_LABEL") 
		andValueName:loan.name];
	  
	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_LOAN_TAXES_FIELD_LABEL")
		andFormInfoCreator:[[[ItemizedLoanTaxFormInfoCreator alloc] initWithLoan:loan
		andIsForNewObject:self.isForNewObject] autorelease]
		andItemizedTaxAmtsInfo:loan.loanInterestItemizedTaxAmts];
		
			 
	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LOAN_DOWN_PMT_SECTION_TITLE")];
	BoolFieldShowHideCondition *showOrHideDownPaymentFieldsCondition = [self.formPopulator populateConditionalFieldVisibilityMultiScenBoolField:loan.downPmtEnabled
			withLabel:LOCALIZED_STR(@"INPUT_LOAN_DOWN_PMT_ENABLED_LABEL")];
	[self.formPopulator populateLoanDownPmtPercent:loan withValueLabel:LOCALIZED_STR(@"INPUT_LOAN_DOWN_PMT_PERCENT_FIELD_LABEL") andValueName:loan.name
		andShowHideCondition:showOrHideDownPaymentFieldsCondition];

	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_SECTION_TITLE")];
	BoolFieldShowHideCondition *showOrHideExtraPaymentFieldsCondition = [self.formPopulator populateConditionalFieldVisibilityMultiScenBoolField:loan.extraPmtEnabled
			withLabel:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_ENABLED_LABEL")];
	[self.formPopulator populateMultiScenarioAmount:loan.extraPmtAmt 
		withValueTitle:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_AMT_AMOUNT_FIELD_LABEL")
		andValueName:loan.name withShowHideCondition:showOrHideExtraPaymentFieldsCondition];
	[self.formPopulator populateMultiScenarioGrowthRate:loan.extraPmtGrowthRate withLabel:LOCALIZED_STR(@"INPUT_LOAN_EXTRA_PMT_GROWTH_RATE_FIELD_LABEL")
			andValueName:loan.name withShowHideCondition:showOrHideExtraPaymentFieldsCondition];
		
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
				
				
	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LOAN_DEFER_PMT_SECTION_TITLE")
		andHelpFile:@"loan" andAnchorWithinHelpFile:@"deferred-payments"];
	BoolFieldShowHideCondition *showOrHideDeferredPaymentFieldsCondition = [self.formPopulator
			populateConditionalFieldVisibilityMultiScenBoolField:loan.deferredPaymentEnabled
			withLabel:LOCALIZED_STR(@"INPUT_LOAN_DEFER_PMT_ENABLED_LABEL")];
	[self.formPopulator populateLoanDeferPaymentDate:loan
		withFieldLabel:LOCALIZED_STR(@"INPUT_LOAN_DEFER_PAYMENT_FIELD_LABEL")
		withShowHideCondition:showOrHideDeferredPaymentFieldsCondition];
	[self.formPopulator populateMultiScenBoolField:loan.deferredPaymentPayInterest
			withLabel:LOCALIZED_STR(@"INPUT_LOAN_DEFER_PMT_PAY_INTEREST")
			andShowHideCondition:showOrHideDeferredPaymentFieldsCondition];
	[self.formPopulator populateMultiScenBoolField:loan.deferredPaymentSubsizedInterest
			withLabel:LOCALIZED_STR(@"INPUT_LOAN_DEFER_PMT_INTEREST_SUBSIDIZED")
			andShowHideCondition:showOrHideDeferredPaymentFieldsCondition];

				
}

- (void)visitAsset:(AssetInput*)asset
{
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_ASSET_TITLE");
	
		NSArray *iconNames = [NSArray arrayWithObjects:
			// Assets/Accounts
			@"input-icon-moneybag.png",		
			@"input-icon-money.png",
			
			// Home & Auto
			@"input-icon-home.png",
			@"input-icon-car.png",
					
			// Travel and Leisure
			@"input-icon-airplane.png",
			@"input-icon-boat.png",
		nil];		
	
	
	[self.formPopulator populateInputNameField:asset withIconList:iconNames];
	[self.formPopulator populateNoteFieldInParentObj:asset
		withNameField:INPUT_NOTES_KEY
		andFieldTitle:LOCALIZED_STR(@"INPUT_NOTE_FIELD_TITLE")
		andPlaceholder:LOCALIZED_STR(@"INPUT_NOTE_FIELD_PLACEHOLDER")];
	[self.formPopulator.currentSection addFieldEditInfo:
			[[[InputTagsFieldEditInfo alloc] initWithInput:asset] autorelease]];
	
	[formPopulator nextSection];
	
	[self.formPopulator populateMultiScenBoolField:asset.assetEnabled 
			withLabel:LOCALIZED_STR(@"INPUT_ASSET_ENABLED_FIELD_LABEL")];
	
	
    if([asset purchaseDateDefinedAndInThePastForScenario:formPopulator.inputScenario usingDateHelper:self.dateHelper])
    {
 		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_ASSET_VALUE_SECTION_TITLE")
                                andHelpFile:@"asset" andAnchorWithinHelpFile:@"current-asset-value"];       
        [self.formPopulator populateCurrencyField:asset andValKey:INPUT_ASSET_STARTING_VALUE_KEY
                andLabel:LOCALIZED_STR(@"INPUT_ASSET_STARTING_VALUE_LABEL")
                andPlaceholder:LOCALIZED_STR(@"INPUT_ASSET_STARTING_VALUE_PLACEHOLDER")];
    }

	[formPopulator nextSectionWithTitle:
        LOCALIZED_STR(@"INPUT_ASSET_VALUE_APPREC_RATE_SECTION_NAME")
        andHelpFile:@"asset" andAnchorWithinHelpFile:@"appreciation-and-depreciation"];
    
	[self.formPopulator populateMultiScenarioApprecRate:asset.apprecRateBeforePurchase
               withLabel:LOCALIZED_STR(@"INPUT_ASSET_VALUE_PRE_PURCHASE_APPREC_RATE_FIELD_LABEL")
                andValueName:asset.name];
	[self.formPopulator populateMultiScenarioApprecRate:asset.apprecRate
		withLabel:LOCALIZED_STR(@"INPUT_ASSET_VALUE_APPREC_RATE_FIELD_LABEL")
			andValueName:asset.name];

	
	[formPopulator nextSectionWithTitle:
		LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_SALE_SECTION_TITLE")]; 
 
	NSString *assetPurchaseDateSubheader = [StringValidation nonEmptyString:asset.name]?
		[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_TABLE_SUBHEADER_FORMAT"),asset.name]:
		LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_TABLE_SUBHEADER_FORMAT_NO_NAME");
 
	[self.formPopulator populateMultiScenSimDate:asset.purchaseDate 
		andLabel:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_FIELD_LABEL") 
		andTitle:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_TITLE")
		andTableHeader:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_TABLE_HEADER")
		 andTableSubHeader:assetPurchaseDateSubheader];
		 
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
				
 	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_ASSET_TAXES_FIELD_TITLE")
			andFormInfoCreator:[[[ItemizedAssetTaxFormInfoCreator alloc] initWithAsset:asset
				andIsForNewObject:self.isForNewObject] autorelease]
			andItemizedTaxAmtsInfo:asset.assetGainItemizedTaxAmts];
			
	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_ASSET_LOSS_TAXES_FIELD_TITLE")
			andFormInfoCreator:[[[ItemizedAssetLossTaxFormInfoCreator alloc] initWithAsset:asset
				andIsForNewObject:self.isForNewObject] autorelease]
			andItemizedTaxAmtsInfo:asset.assetLossItemizedTaxAmts];
		

}

- (void)visitTax:(TaxInput *)tax
{
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_TAX_TITLE");
	
	NSArray *iconNames = [NSArray arrayWithObjects:
		@"input-icon-taxes.png",
		@"input-icon-investtax.png",
		nil];
	
	[self.formPopulator populateInputNameField:tax withIconList:iconNames];
	[self.formPopulator populateNoteFieldInParentObj:tax
		withNameField:INPUT_NOTES_KEY
		andFieldTitle:LOCALIZED_STR(@"INPUT_NOTE_FIELD_TITLE")
		andPlaceholder:LOCALIZED_STR(@"INPUT_NOTE_FIELD_PLACEHOLDER")];
	[self.formPopulator.currentSection addFieldEditInfo:
			[[[InputTagsFieldEditInfo alloc] initWithInput:tax] autorelease]];
	
	[formPopulator nextSection];
	
	[self.formPopulator populateMultiScenBoolField:tax.taxEnabled  
		withLabel:LOCALIZED_STR(@"INPUT_TAX_ENABLED_FIELD_LABEL")];
		
	// Tax Bracket Section
	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_TAX_BRACKET_SECTION_TITLE")
		andHelpFile:@"tax" andAnchorWithinHelpFile:@"tax-rates"];
		
	Scenario *currentScenario = self.formPopulator.inputScenario;
	SharedAppValues *sharedAppVals = [SharedAppValues getUsingDataModelController:self.formPopulator.formContext.dataModelController];
	NSDate *simStartDate = sharedAppVals.simStartDate;
	
	
	TaxBracketFormInfoCreator *taxBracketFormInfoCreator =
		[[[TaxBracketFormInfoCreator alloc] initWithTaxBracket:tax.taxBracket andIsForNewObject:self.isForNewObject] autorelease];
	// TODO - Add a subtitle which summarizes the tax bracket
	StaticNavFieldEditInfo *taxRatesFieldEditInfo = [[[StaticNavFieldEditInfo alloc]
		initWithCaption:LOCALIZED_STR(@"INPUT_TAX_RATES_FIELD_LABEL")
			andSubtitle:[tax.taxBracket taxBracketSummaryForScenario:currentScenario andDate:simStartDate]
			andContentDescription:nil andSubFormInfoCreator:taxBracketFormInfoCreator] autorelease];
	[formPopulator.currentSection addFieldEditInfo:taxRatesFieldEditInfo];
	
	[formPopulator populateMultiScenarioGrowthRate:tax.taxBracket.cutoffGrowthRate 
		withLabel:LOCALIZED_STR(@"INPUT_TAX_CUTOFF_GROWTH_RATE_FIELD_LABEL")
		 andValueName:LOCALIZED_STR(@"INPUT_TAX_CUTOFF_GROWTH_RATE_VALUE_NAME")];

	
	// TODO - Double-check how the ItemizedTaxAmtsInfo's specify what is itemized versus the 
	// typical federal and state tax structures.

	// Tax Sources Section

	[formPopulator 
		nextSectionWithTitle:LOCALIZED_STR(@"INPUT_TAX_SOURCES_SECTION_TITLE")
		andHelpFile:@"tax" andAnchorWithinHelpFile:@"tax-sources"];
	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_SOURCES_TITLE") 
			andItemizedTaxAmtsFormInfoCreator:[[[ItemizedTaxAmtsSelectionFormInfoCreator alloc]
				initWithItemizedTaxAmtsInfo:[ItemizedTaxAmtsInfo taxSourceInfo:tax 
						usingDataModelController:self.formContext.dataModelController]
				andIsForNewObject:self.isForNewObject] autorelease]];		

	// Adjustments Section

	[formPopulator 
		nextSectionWithTitle:LOCALIZED_STR(@"INPUT_TAX_ADJUSTMENT_SECTION_TITLE")
		andHelpFile:@"tax" andAnchorWithinHelpFile:@"adjustments"];
	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ADJUSTMENTS_TITLE")
		andItemizedTaxAmtsFormInfoCreator:[[[ItemizedTaxAmtsSelectionFormInfoCreator alloc] 
			initWithItemizedTaxAmtsInfo:[ItemizedTaxAmtsInfo taxAdjustmentInfo:tax 
						usingDataModelController:self.formContext.dataModelController]
			andIsForNewObject:self.isForNewObject] autorelease]];
	
	// Exemptions Section
	[formPopulator 
		nextSectionWithTitle:LOCALIZED_STR(@"INPUT_TAX_EXEMPTION_SECTION_TITLE")
		andHelpFile:@"tax" andAnchorWithinHelpFile:@"exemptions"];
	
	[self.formPopulator populateMultiScenarioAmount:tax.exemptionAmt 
		withValueTitle:LOCALIZED_STR(@"INPUT_TAX_EXEMPTION_AMOUNT_TITLE")
		andValueName:tax.name];
		
	
	[self.formPopulator populateMultiScenarioGrowthRate:tax.exemptionGrowthRate 
		withLabel:LOCALIZED_STR(@"INPUT_TAX_EXEMPTION_GROWTH_RATE_LABEL")
			andValueName:tax.name];

	// Deductions Section

	[formPopulator 
		nextSectionWithTitle:LOCALIZED_STR(@"INPUT_TAX_DEDUCTION_SECTION_TITLE")
		andHelpFile:@"tax" andAnchorWithinHelpFile:@"deductions"];

	[self.formPopulator populateMultiScenarioAmount:tax.stdDeductionAmt 
		withValueTitle:LOCALIZED_STR(@"INPUT_TAX_STD_DEDUCTION_TITLE")
		andValueName:tax.name];

	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_DEDUCTIONS_TITLE") 
		andItemizedTaxAmtsFormInfoCreator:[[[ItemizedTaxAmtsSelectionFormInfoCreator alloc] 
			initWithItemizedTaxAmtsInfo:[ItemizedTaxAmtsInfo taxDeductionInfo:tax 
						usingDataModelController:self.formContext.dataModelController]
			andIsForNewObject:self.isForNewObject] autorelease]];	

	[self.formPopulator populateMultiScenarioGrowthRate:tax.stdDeductionGrowthRate  
		withLabel:LOCALIZED_STR(@"INPUT_TAX_STD_DEDUCTION_GROWTH_RATE_LABEL")
		andValueName:tax.name];

	// Tax Credits Section
		
	[formPopulator 
		nextSectionWithTitle:LOCALIZED_STR(@"INPUT_TAX_CREDITS_SECTION_TITLE")
		andHelpFile:@"tax" andAnchorWithinHelpFile:@"credits"];
	[formPopulator populateItemizedTaxSelectionWithFieldLabel:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_CREDITS_TITLE")
		andItemizedTaxAmtsFormInfoCreator:[[[ItemizedTaxAmtsSelectionFormInfoCreator alloc]
		initWithItemizedTaxAmtsInfo:[ItemizedTaxAmtsInfo taxCreditInfo:tax 
						usingDataModelController:self.formContext.dataModelController]
			andIsForNewObject:self.isForNewObject] autorelease]];	
	

}




@end
