//
//  UserScenarioFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserScenarioFormInfoCreator.h"
#import "FormPopulator.h"
#import "LocalizationHelper.h"
#import "UserScenario.h"
#import "NameFieldEditInfo.h"
#import "NameFieldCell.h"
#import "ManagedObjectFieldInfo.h"
#import "SectionInfo.h"

#import "ScenarioInputValBacktracer.h"
#import "InputFormPopulator.h"
#import "CashFlowInput.h"
#import "Account.h"
#import "TaxInput.h"
#import "AssetInput.h"

#import "PositiveAmountValidator.h"
#import "PositiveNumberValidator.h"
#import "LoanInput.h"
#import "VariableValueRuntimeInfo.h"
#import "LoanDownPmtPercent.h"
#import "DateSensitiveValueFieldEditInfo.h"
#import "FormContext.h"
#import "NoteFieldEditInfo.h"
#import "InputFormPopulator.h"
#import "ScenarioNameValidator.h"
#import "FormContext.h"
#import "AccountWithdrawalOrderInfo.h"
#import "AccountWithdrawalOrderFieldEditInfo.h"

@implementation UserScenarioFormInfoCreator

@synthesize userScen;
@synthesize editNameAsFirstResponder;

-(id)initWithUserScenario:(UserScenario*)theScenario
{
	self = [super init];
	if(self)
	{
		self.userScen = theScenario;
        self.editNameAsFirstResponder = FALSE;
	}
	return self;
}


- (id) init
{
	assert(0); // must call init above.
	return nil;
}


- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
	InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] 
			initWithScenario:self.userScen
			andFormContext:parentContext] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"SCENARIO_DETAIL_VIEW_TITLE");
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	
	ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] 
		initWithManagedObject:self.userScen andFieldKey:USER_SCENARIO_NAME_KEY 
		andFieldLabel:LOCALIZED_STR(@"SCENARIO_NAME_FIELD_LABEL") 
		andFieldPlaceholder:LOCALIZED_STR(@"SCENARIO_NAME_PLACEHOLDER")] autorelease];
		
	ManagedObjectFieldInfo *imageFieldInfo = [[[ManagedObjectFieldInfo alloc]
		initWithManagedObject:self.userScen
		andFieldKey:SCENARIO_ICON_IMAGE_NAME_KEY
		andFieldLabel:@"N/A" andFieldPlaceholder:@"N/A"] autorelease];

	// TODO - Populate with names array which is specific to the input type
	// (passed in as a parameter).
	NSArray *imageNames = [NSArray arrayWithObjects:
	
			@"scenario-icon-scale.png",
            @"scenario-icon-clock.png",
			
			@"input-icon-expense.png",
			@"input-icon-income.png",
			@"input-icon-briefcase.png",
			
			@"input-icon-money.png",
			@"input-icon-moneybag.png",
			@"input-icon-piggybank.png",
			@"input-icon-invest.png",

			@"input-icon-home.png",
			@"input-icon-apartment.png",

			@"input-icon-college.png",
			@"input-icon-wedding.png",
			@"input-icon-vacation.png",
			@"input-icon-airplane.png",
			@"input-icon-boat.png",
			@"input-icon-car.png",
			@"input-icon-medical.png",
			
		nil];
		
	ScenarioNameValidator *scenNameValidator = [[[ScenarioNameValidator alloc]
		initWithScenario:self.userScen andDataModelController:parentContext.dataModelController] autorelease];
		
	NameFieldEditInfo *fieldEditInfo = [[[NameFieldEditInfo alloc] initWithFieldInfo:fieldInfo
		andCustomValidator:scenNameValidator andParentController:parentContext.parentController
		andImageNames:imageNames andImageFieldInfo:imageFieldInfo] autorelease];
    
    if(self.editNameAsFirstResponder && ![fieldInfo fieldIsInitializedInParentObject])
    {
        formPopulator.formInfo.firstResponder = fieldEditInfo.cell.textField;        
    }
	
    [sectionInfo addFieldEditInfo:fieldEditInfo];
	
	[formPopulator populateNoteFieldInParentObj:self.userScen
		withNameField:USER_SCENARIO_NOTES_KEY
		andFieldTitle:LOCALIZED_STR(@"SCENARIO_NOTE_FIELD_TITLE")
		andPlaceholder:LOCALIZED_STR(@"SCENARIO_NOTE_FIELD_PLACEHOLDER")];
	
	ScenarioInputValBacktracer *inputBacktrace = [[[ScenarioInputValBacktracer alloc] 
			initWithUserScen:self.userScen] autorelease];
			
	// TODO - Rethink the ordering of the fields/sections below
		
	if([inputBacktrace.accountContribEnabled count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_ACCOUNT_CONTRIBS");
		for(Account *acct in inputBacktrace.accountContribEnabled)
		{
			[formPopulator populateMultiScenBoolField:acct.contribEnabled withLabel:acct.name];
		}
	}
	
	if([inputBacktrace.accountDividendEnabled count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_ACCOUNT_DIVIDENDS");
		for(Account *acct in inputBacktrace.accountDividendEnabled)
		{
			[formPopulator populateMultiScenBoolField:acct.dividendEnabled withLabel:acct.name];
		}
	}
	
	if([inputBacktrace.accountContribRepeatFrequency count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ACCOUNT_CONTRIB_FREQUENCY");
		for(Account *acct in inputBacktrace.accountContribRepeatFrequency)
		{
			[formPopulator populateRepeatFrequency:acct.contribRepeatFrequency
				andLabel:acct.name]; 
		}
	}
	
	if([inputBacktrace.accountDeferredWithdrawalsEnabled count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ACCOUNT_DEFERRED_WITHDRAWALS");
		for(Account *acct in inputBacktrace.accountDeferredWithdrawalsEnabled)
		{
			[formPopulator populateMultiScenBoolField:acct.deferredWithdrawalsEnabled 
					withLabel:acct.name];
		}
	}

	if([inputBacktrace.accountWithdrawalPriority count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_WITHDRAWAL_PRIORITY_SECTION_TITLE");

		NSArray *sortedWithdrawalOrderInfos = [AccountWithdrawalOrderInfo sortedWithdrawalOrderInfosFromAccountSet:
			inputBacktrace.accountWithdrawalPriority
			andDmc:formPopulator.formContext.dataModelController underScenario:self.userScen];
		
		for(AccountWithdrawalOrderInfo *acctWithOrderInfo in sortedWithdrawalOrderInfos)
		{
			AccountWithdrawalOrderFieldEditInfo *withdrawalFieldEditInfo =
				[[[AccountWithdrawalOrderFieldEditInfo alloc]
				initWithAccountWithdrawalOrderInfo:acctWithOrderInfo
				andCaption:acctWithOrderInfo.account.name  andSubtitle:@""] autorelease];
			[formPopulator.currentSection addFieldEditInfo:withdrawalFieldEditInfo];
		}
	}
	
	
	if([inputBacktrace.loanDownPmtEnabled count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_LOAN_DOWN_PMT");
		for(LoanInput *loan in inputBacktrace.loanDownPmtEnabled)
		{
			[formPopulator populateMultiScenBoolField:loan.downPmtEnabled 
					withLabel:loan.name];
		}
	}

	if([inputBacktrace.loanDownPmtPercent count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_LOAN_DOWN_PMT_PERCENT");
		for(LoanInput *loan in inputBacktrace.loanDownPmtPercent)
		{
			[formPopulator populateLoanDownPmtPercent:loan 
				withValueLabel:loan.name andValueName:loan.name];
		}
	}

	if([inputBacktrace.loanDuration count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_LOAN_DURATION");
		for(LoanInput *loan in inputBacktrace.loanDuration)
		{
			[formPopulator populateMultiScenarioDuration:loan.loanDuration 
				andLabel:loan.name 
				andPlaceholder:LOCALIZED_STR(@"INPUT_LOAN_DURATION_PLACEHOLDER") ];
		}
	}


	if([inputBacktrace.loanEnabled count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_LOAN");
		for(LoanInput *loan in inputBacktrace.loanEnabled)
		{
			[formPopulator populateMultiScenBoolField:loan.loanEnabled 
					withLabel:loan.name];
		}
	}


	if([inputBacktrace.loanExtraPmtEnabled count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_LOAN_EXTRA_PMT");
		for(LoanInput *loan in inputBacktrace.loanExtraPmtEnabled)
		{
			[formPopulator populateMultiScenBoolField:loan.extraPmtEnabled 
					withLabel:loan.name];
		}
	}

/* TBD: loanExtraPmtFrequency appears not to be used - either fully define it or strip out 
	if([inputBacktrace.loanExtraPmtFrequency count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_LOAN_EXTRA_PMT");
		for(LoanInput *loan in inputBacktrace.loanExtraPmtFrequency)
		{
		}
	}
*/
	if([inputBacktrace.cashFlowEnabled count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_CASH_FLOW");
		for(CashFlowInput *cashFlow in inputBacktrace.cashFlowEnabled)
		{
			[formPopulator populateMultiScenBoolField:cashFlow.cashFlowEnabled 
					withLabel:cashFlow.name];
		}
	}


	if([inputBacktrace.cashFlowRepeatFrequency count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_FREQUENCY_CASH_FLOW");
		for(CashFlowInput *cashFlow in inputBacktrace.cashFlowRepeatFrequency)
		{
			[formPopulator populateRepeatFrequency:cashFlow.eventRepeatFrequency
				andLabel:cashFlow.name];
		}
	}


	if([inputBacktrace.taxEnabled count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_TAX");
		for(TaxInput *tax in inputBacktrace.taxEnabled)
		{
			[formPopulator populateMultiScenBoolField:tax.taxEnabled 
					withLabel:tax.name];
		}
	}

	if([inputBacktrace.assetEnabled count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_ENABLED_ASSET");
		for(AssetInput *asset in inputBacktrace.assetEnabled)
		{
			[formPopulator populateMultiScenBoolField:asset.assetEnabled 
					withLabel:asset.name];
		}
	}

	if([inputBacktrace.accountContribAmount count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_ACCOUNT_CONTRIBS");
		for(Account *acct in inputBacktrace.accountContribAmount)
		{
			[formPopulator populateMultiScenarioAmount:acct.contribAmount 
				withValueTitle:acct.name
				andValueName:acct.name];
		}
	}

	if([inputBacktrace.assetCost count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_ASSET_COST");
		for(AssetInput *asset in inputBacktrace.assetCost)
		{
			[formPopulator populateMultiScenarioAmount:asset.cost 
				withValueTitle:asset.name
				andValueName:asset.name];
		}
	}

	if([inputBacktrace.taxExemptionAmt count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_TAX_EXEMPTION");
		for(TaxInput *tax in inputBacktrace.taxExemptionAmt)
		{
			[formPopulator populateMultiScenarioAmount:tax.exemptionAmt 
				withValueTitle:tax.name
				andValueName:tax.name];
		}
	}

	if([inputBacktrace.taxStdDeductionAmt count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_TAX_STD_DEDUCTION");
		for(TaxInput *tax in inputBacktrace.taxStdDeductionAmt)
		{
			[formPopulator populateMultiScenarioAmount:tax.stdDeductionAmt 
				withValueTitle:tax.name
				andValueName:tax.name];
		}
	}

	if([inputBacktrace.cashFlowAmount count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_CASH_FLOW");
		for(CashFlowInput *cashFlow in inputBacktrace.cashFlowAmount)
		{
			[formPopulator populateMultiScenarioAmount:cashFlow.amount 
				withValueTitle:cashFlow.name
				andValueName:cashFlow.name];
		}
	}

	if([inputBacktrace.loanCost count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_LOAN_COST");
		for(LoanInput *loan in inputBacktrace.loanCost)
		{
			[formPopulator populateMultiScenarioLoanOrigAmount:loan.loanCost 
				withValueTitle:loan.name
				andValueName:loan.name];
		}
	}

	if([inputBacktrace.loanExtraPmtAmt count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_AMOUNTS_LOAN_EXTRA_PMT");
		for(LoanInput *loan in inputBacktrace.loanExtraPmtAmt)
		{
			[formPopulator populateMultiScenarioAmount:loan.extraPmtAmt 
				withValueTitle:loan.name
				andValueName:loan.name];
		}
	}


	if([inputBacktrace.accountContribGrowthRate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_ACCOUNT_CONTRIBS");
		for(Account *acct in inputBacktrace.accountContribGrowthRate)
		{
			[formPopulator populateMultiScenarioGrowthRate:acct.contribGrowthRate 
				withLabel:acct.name 
				andValueName:acct.name];
		}
	}

	if([inputBacktrace.accountInterestRate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_RETURN_ACCOUNT_INTEREST");
		for(Account *acct in inputBacktrace.accountInterestRate)
		{
			[formPopulator populateMultiScenarioInvestmentReturnRate:acct.interestRate 
				withLabel:acct.name
				andValueName:acct.name];
		}
	}
		
	if([inputBacktrace.accountDividendRate count] > 0)
	{
		[formPopulator
			nextSectionWithTitle:LOCALIZED_STR(@"WHAT_IF_RETURN_ACCOUNT_DIVIDEND")];
		for(Account *acct in inputBacktrace.accountDividendRate)
		{
			[formPopulator populateMultiScenarioDividendReturnRate:acct.dividendRate
				withLabel:acct.name
				andValueName:acct.name];
		}
	}

	if([inputBacktrace.accountDividendReinvestPercent count] > 0)
	{
		[formPopulator
			nextSectionWithTitle:LOCALIZED_STR(@"WHAT_IF_ACCOUNT_DIVIDENT_REINVEST_PERCENT")];
		for(Account *acct in inputBacktrace.accountDividendReinvestPercent)
		{
			[formPopulator populateMultiScenarioDividendReinvestPercent:acct.dividendReinvestPercent
				withLabel:acct.name
				andValueName:acct.name];
		}
	}


	if([inputBacktrace.assetApprecRate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_RETURN_ASSET_APPRECIATION");
		for(AssetInput *asset in inputBacktrace.assetApprecRate)
		{
			[formPopulator populateMultiScenarioApprecRate:asset.apprecRate 
				withLabel:asset.name
				andValueName:asset.name]; 
		}
	}

    if([inputBacktrace.assetApprecRateBeforePurchase count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_RETURN_PRE_PURCHASE_ASSET_APPRECIATION");
		for(AssetInput *asset in inputBacktrace.assetApprecRateBeforePurchase)
		{
			[formPopulator populateMultiScenarioApprecRate:asset.apprecRateBeforePurchase
                                                 withLabel:asset.name
                                              andValueName:asset.name]; 
		}
	}

	if([inputBacktrace.taxExemptionGrowthRate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_TAX_EXEMPTION");
		for(TaxInput *tax in inputBacktrace.taxExemptionGrowthRate)
		{
			[formPopulator populateMultiScenarioGrowthRate:tax.exemptionGrowthRate 
				withLabel:tax.name
					andValueName:tax.name];
		}
	}

	if([inputBacktrace.taxStdDeductionGrowthRate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_TAX_STD_DEDUCTION");
		for(TaxInput *tax in inputBacktrace.taxStdDeductionGrowthRate)
		{
			[formPopulator populateMultiScenarioGrowthRate:tax.stdDeductionGrowthRate 
				withLabel:tax.name
					andValueName:tax.name];
		}
	}

	if([inputBacktrace.cashFlowAmountGrowthRate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_CASH_FLOW");
		for(CashFlowInput *cashFlow in inputBacktrace.cashFlowAmountGrowthRate)
		{
			[formPopulator populateMultiScenarioGrowthRate:cashFlow.amountGrowthRate 
				withLabel:cashFlow.name
					andValueName:cashFlow.name];
		}
	}

	if([inputBacktrace.loanCostGrowthRate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_LOAN_COST");
		for(LoanInput *loan in inputBacktrace.loanCostGrowthRate)
		{
			[formPopulator populateMultiScenarioGrowthRate:loan.loanCostGrowthRate 
				withLabel:loan.name
				andValueName:loan.name];
		}
	}

	if([inputBacktrace.loanExtraPmtGrowthRate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_LOAN_EXTRA_PMT");
		for(LoanInput *loan in inputBacktrace.loanExtraPmtGrowthRate)
		{
			[formPopulator populateMultiScenarioGrowthRate:loan.extraPmtGrowthRate 
				withLabel:loan.name
				andValueName:loan.name];
		}
	}


	if([inputBacktrace.loanInterestRate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_GROWTH_RATE_LOAN_INTEREST");
		for(LoanInput *loan in inputBacktrace.loanInterestRate)
		{
			[formPopulator populateMultiScenarioInterestRate:loan.interestRate 
				withLabel:loan.name
				andValueName:loan.name];
		}
	}

	// TBD - Only Show end dates if the repeat frequency is more than once?

	if([inputBacktrace.accountContribEndDate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_END_DATE_ACCOUNT_CONTRIB");
		for(Account *acct in inputBacktrace.accountContribEndDate)
		{
			// TODO - Test to ensure the display of values is correct
			[formPopulator populateMultiScenSimEndDate:acct.contribEndDate 
				andLabel:acct.name
				andTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_END_DATE_TABLE_TITLE")
				andTableHeader:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_END_DATE_TABLE_HEADER")
				 andTableSubHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_END_DATE_TABLE_SUBHEADER_FORMAT"),acct.name]

				andNeverEndFieldTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_NEVER_END_FIELD_TITLE")
				andNeverEndFieldSubtitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_NEVER_END_FIELD_SUBTITLE")
				andNeverEndSectionTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_CONTRIB_NEVER_END_SECTION_TITLE") 
				andNeverEndHelpInfo:@"neverEndDateContrib"
				andRelEndDateSectionTitle:LOCALIZED_STR(@"SIM_DATE_RELATIVE_ENDING_DATE_SECTION_TITLE") 
				andRelEndDateHelpFile:@"relEndDateContrib"
				andRelEndDateFieldLabel:LOCALIZED_STR(@"RELATIVE_END_DATE_FIELD_LABEL")];
		}
	}

	if([inputBacktrace.assetSaleDate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_END_DATE_ASSET_SALE");
		for(AssetInput *asset in inputBacktrace.assetSaleDate)
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
						andNeverEndHelpInfo:@"neverEndDateSell"
						andRelEndDateSectionTitle:LOCALIZED_STR(@"INPUT_ASSET_SALE_REL_END_DATE_SECTION_TITLE")
						andRelEndDateHelpFile:@"relEndDateSell"
						andRelEndDateFieldLabel:LOCALIZED_STR(@"INPUT_ASSET_SALE_REL_END_DATE_FIELD_LABEL")
						];
		}
	}

	if([inputBacktrace.cashFlowEndDate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_END_DATE_CASH_FLOW");
		for(CashFlowInput *cashFlow in inputBacktrace.cashFlowEndDate)
		{
			[formPopulator populateMultiScenSimEndDate:cashFlow.endDate 
				andLabel:cashFlow.name 
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

	
	if([inputBacktrace.accountContribStartDate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_START_DATE_CONTRIB");
		for(Account *acct in inputBacktrace.accountContribStartDate)
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
	
	if([inputBacktrace.accountDeferredWithdrawalDate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_START_DATE_DEFERRED_WITHDRAWAL");
		for(Account *acct in inputBacktrace.accountDeferredWithdrawalDate)
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
	
	if([inputBacktrace.assetPurchaseDate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_START_DATE_ASSET_PURCHASE");
		for(AssetInput *asset in inputBacktrace.assetPurchaseDate)
		{
			[formPopulator populateMultiScenSimDate:asset.purchaseDate 
				andLabel:asset.name 
				andTitle:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_TITLE")
				andTableHeader:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_TABLE_HEADER")
				 andTableSubHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_ASSET_PURCHASE_DATE_TABLE_SUBHEADER_FORMAT"),asset.name]];
		}
	}


	if([inputBacktrace.cashFlowStartDate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_START_DATE_CASH_FLOW");
		for(CashFlowInput *cashFlow in inputBacktrace.cashFlowStartDate)
		{
			[formPopulator populateMultiScenSimDate:cashFlow.startDate 
				andLabel:cashFlow.name 
				andTitle:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TITLE")
				andTableHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TABLE_HEADER_FORMAT"),[cashFlow inputTypeTitle]] 
				andTableSubHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_CASH_FLOW_START_DATE_TABLE_SUBHEADER_FORMAT"),
					[cashFlow inlineInputType],cashFlow.name]];
		}
	}

	if([inputBacktrace.loanOrigDate count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_START_DATE_LOAN_ORIG");
		for(LoanInput *loan in inputBacktrace.loanOrigDate)
		{
			[formPopulator populateMultiScenSimDate:loan.origDate 
				andLabel:loan.name 
				andTitle:LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_FIELD_LABEL")
				andTableHeader:LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_TABLE_HEADER") 
				andTableSubHeader:[NSString stringWithFormat:
					LOCALIZED_STR(@"INPUT_LOAN_ORIG_DATE_SUBHEADER_FORMAT"),loan.name]];
		}
	}
	
	if([inputBacktrace.loanEarlyPayoff count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_DATES_LOAN_PAYOFF");
		for(LoanInput *loan in inputBacktrace.loanEarlyPayoff)
		{
			[formPopulator populateMultiScenSimEndDate:loan.earlyPayoffDate 
			andLabel:loan.name 
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
		}
	}


	if([inputBacktrace.loanDeferPayment count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"WHAT_IF_DATES_LOAN_DEFER_PAYMENT");
		for(LoanInput *loan in inputBacktrace.loanDeferPayment)
		{
			[formPopulator populateLoanDeferPaymentDate:loan withFieldLabel:loan.name];
		}
	}

	
	return formPopulator.formInfo;
	
}

-(void) dealloc
{
	[userScen release];
	[super dealloc];
}


@end
