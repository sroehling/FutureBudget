//
//  ItemizedTaxAmtsSelectionFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxAmtsSelectionFormInfoCreator.h"

#import "FormInfo.h"
#import "InputFormPopulator.h"
#import "ItemizedTaxAmts.h"
#import "ItemizedTaxAmt.h"
#import "LocalizationHelper.h"
#import "ItemizedTaxAmtsInfo.h"
#import "InputFormPopulator.h"
#import "ItemizedTaxAmtFieldPopulator.h"
#import "SharedAppValues.h"
#import "Scenario.h"

#import "IncomeItemizedTaxAmt.h"
#import "IncomeInput.h"

#import "ExpenseInput.h"
#import "ExpenseItemizedTaxAmt.h"

#import "Account.h"
#import "AccountInterestItemizedTaxAmt.h"

#import "Account.h"
#import "AccountContribItemizedTaxAmt.h"
#import "AccountWithdrawalItemizedTaxAmt.h"

#import "AssetInput.h"
#import "AssetGainItemizedTaxAmt.h"

#import "TaxInput.h"
#import "TaxesPaidItemizedTaxAmt.h"

#import "LoanInput.h"
#import "LoanInterestItemizedTaxAmt.h"
#import "PercentFieldValidator.h"
#import "SectionInfo.h"
#import "ItemizedTaxAmtFieldEditInfo.h"
#import "ItemizedIncomeTaxAmtCreator.h"
#import "ItemizedExpenseTaxAmtCreator.h"
#import "ItemizedAccountContribTaxAmtCreator.h"
#import "ItemizedAccountWithdrawalTaxAmtCreator.h"
#import "ItemizedAssetGainTaxAmtCreator.h"
#import "ItemizedLoanInterestTaxAmtCreator.h"
#import "ItemizedAccountTaxAmtCreator.h"
#import "ItemizedTaxesPaidTaxAmtCreator.h"
#import "AccountDividendItemizedTaxAmt.h"
#import "ItemizedAccountDividendTaxAmtCreator.h"
#import "ItemizedAccountCapitalGainTaxAmtCreator.h"
#import "ItemizedAccountCapitalLossTaxAmtCreator.h"
#import "AccountCapitalGainItemizedTaxAmt.h"
#import "AccountCapitalLossItemizedTaxAmt.h"
#import "ItemizedAssetLossTaxAmtCreator.h"
#import "AssetLossItemizedTaxAmt.h"

#import "LocalizationHelper.h"
#import "FormContext.h"

@implementation ItemizedTaxAmtsSelectionFormInfoCreator

@synthesize itemizedTaxAmtsInfo;
@synthesize isForNewObject;


-(id)initWithItemizedTaxAmtsInfo:(ItemizedTaxAmtsInfo*)theItemizedTaxAmtsInfo
	andIsForNewObject:(BOOL)forNewObject
{
	self = [super init];
	if(self)
	{
		assert(theItemizedTaxAmtsInfo != nil);
		self.itemizedTaxAmtsInfo = theItemizedTaxAmtsInfo;
		
		self.isForNewObject = forNewObject;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}



- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
	
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] 
		initForNewObject:self.isForNewObject
			andFormContext:parentContext] autorelease];
    
    formPopulator.formInfo.title = self.itemizedTaxAmtsInfo.title;
	ItemizedTaxAmtFieldPopulator *fieldPopulator = 
				self.itemizedTaxAmtsInfo.fieldPopulator;
				
	if([self.itemizedTaxAmtsInfo itemizeIncomes])
	{
		NSArray *incomesNotItemized = [fieldPopulator incomesNotAlreadyItemized];
		if(([fieldPopulator.itemizedIncomes count] > 0) ||
			([incomesNotItemized count] > 0))
		{
			[formPopulator nextSectionWithTitle:[NSString stringWithFormat:
				self.itemizedTaxAmtsInfo.itemSectionTitleFormat,
				LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_INCOME_TITLE")]
				andHelpFile:self.itemizedTaxAmtsInfo.itemHelpInfoFile
				andAnchorWithinHelpFile:self.itemizedTaxAmtsInfo.anchorWithinHelpFile];

			for(IncomeItemizedTaxAmt *itemizedIncome in fieldPopulator.itemizedIncomes )
			{
				// TODO - Migrate the code below (and other instances in this file) to use
				// the formPopulator's "populate" selector for itemized tax amounts.
				ItemizedIncomeTaxAmtCreator *itemCreator = [[[ItemizedIncomeTaxAmtCreator alloc] 
						initWithFormContext:parentContext
						andIncome:itemizedIncome.income 
						andItemLabel:itemizedIncome.income.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *incomeFieldEditInfo = 
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:itemCreator
					andItemizedTaxAmt:itemizedIncome
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:incomeFieldEditInfo];
				
			}
			for(IncomeInput *unitemizedIncome in incomesNotItemized)
			{	
				ItemizedIncomeTaxAmtCreator *itemCreator = [[[ItemizedIncomeTaxAmtCreator alloc] 
						initWithFormContext:parentContext
						andIncome:unitemizedIncome 
						andItemLabel:unitemizedIncome.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *incomeFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc] 
					initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:itemCreator
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo
					andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:incomeFieldEditInfo];
			}
		}
	}

	if([self.itemizedTaxAmtsInfo itemizeExpenses])
	{
		NSArray *expensesNotItemized = [fieldPopulator expensesNotAlreadyItemized];
		if(([fieldPopulator.itemizedExpenses count] > 0) ||
			([expensesNotItemized count] > 0))
		{
			[formPopulator nextSectionWithTitle:[NSString stringWithFormat:
				self.itemizedTaxAmtsInfo.itemSectionTitleFormat,
				LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_EXPENSE_TITLE")]
				andHelpFile:self.itemizedTaxAmtsInfo.itemHelpInfoFile];

			for(ExpenseItemizedTaxAmt *itemizedExpense in fieldPopulator.itemizedExpenses )
			{
				ItemizedTaxAmtFieldEditInfo *expenseFieldEditInfo = 
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:
							[[[ItemizedExpenseTaxAmtCreator alloc] 
								initWithFormContext:parentContext 
								andExpense:itemizedExpense.expense 
								andLabel:itemizedExpense.expense.name] autorelease]
					andItemizedTaxAmt:itemizedExpense
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:expenseFieldEditInfo];
			}
			for(ExpenseInput *unitemizedExpense in expensesNotItemized)
			{	
				ItemizedTaxAmtFieldEditInfo *expenseFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc] 
					initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:
						[[[ItemizedExpenseTaxAmtCreator alloc] 
						initWithFormContext:parentContext 
						andExpense:unitemizedExpense 
						andLabel:unitemizedExpense.name] autorelease]
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:expenseFieldEditInfo];
			}
		}
	}


	if([self.itemizedTaxAmtsInfo itemizeAccountInterest])
	{
		NSArray *acctInterestNotItemized = [fieldPopulator acctInterestNotAlreadyItemized];
		if(([fieldPopulator.itemizedAccountInterest count] > 0) ||
			([acctInterestNotItemized count] > 0))
		{
			[formPopulator nextSectionWithTitle:[NSString stringWithFormat:
				self.itemizedTaxAmtsInfo.itemSectionTitleFormat,
				LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ACCT_INTEREST_TITLE")]
				andHelpFile:self.itemizedTaxAmtsInfo.itemHelpInfoFile];

			for(AccountInterestItemizedTaxAmt *itemizedAcctInterest in fieldPopulator.itemizedAccountInterest )
			{
				ItemizedAccountTaxAmtCreator *itemizedAcctTaxInterestCreator = 
					[[[ItemizedAccountTaxAmtCreator alloc] 
								initWithFormContext:parentContext 
								andAcct:itemizedAcctInterest.account 
								andLabel:itemizedAcctInterest.account.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctInterestFieldEditInfo = 
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:itemizedAcctTaxInterestCreator
					andItemizedTaxAmt:itemizedAcctInterest
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctInterestFieldEditInfo];
				
			}
			for(Account *unitemizedAcct in acctInterestNotItemized)
			{	
				ItemizedAccountTaxAmtCreator *itemizedAcctTaxInterestCreator = 
					[[[ItemizedAccountTaxAmtCreator alloc] initWithFormContext:parentContext
						andAcct:unitemizedAcct
						andLabel:unitemizedAcct.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctInterestFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc] 
					initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:itemizedAcctTaxInterestCreator
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctInterestFieldEditInfo];
			}
		}
	}

	if([self.itemizedTaxAmtsInfo itemizeAccountDividends])
	{
		NSArray *acctDivNotItemized = [fieldPopulator acctDividendNotAlreadyItemized];
		if(([fieldPopulator.itemizedAccountDividend count] > 0) ||
			([acctDivNotItemized count] > 0))
		{
			[formPopulator nextSectionWithTitle:[NSString stringWithFormat:
				self.itemizedTaxAmtsInfo.itemSectionTitleFormat,
				LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ACCT_DIVIDEND_TITLE")]
				andHelpFile:self.itemizedTaxAmtsInfo.itemHelpInfoFile];

			for(AccountDividendItemizedTaxAmt *itemizedAcctDiv in fieldPopulator.itemizedAccountDividend )
			{
				ItemizedAccountDividendTaxAmtCreator *itemizedAcctTaxDivCreator =
					[[[ItemizedAccountDividendTaxAmtCreator alloc] 
								initWithFormContext:parentContext 
								andAcct:itemizedAcctDiv.account 
								andLabel:itemizedAcctDiv.account.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctDivFieldEditInfo =
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:itemizedAcctTaxDivCreator
					andItemizedTaxAmt:itemizedAcctDiv
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctDivFieldEditInfo];
				
			}
			for(Account *unitemizedAcct in acctDivNotItemized)
			{	
				ItemizedAccountDividendTaxAmtCreator *itemizedAcctTaxDivCreator =
					[[[ItemizedAccountDividendTaxAmtCreator alloc] initWithFormContext:parentContext
						andAcct:unitemizedAcct
						andLabel:unitemizedAcct.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctDivFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc]
					initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:itemizedAcctTaxDivCreator
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctDivFieldEditInfo];
			}
		}
	}


	if([self.itemizedTaxAmtsInfo itemizeAccountCapitalGains])
	{
		NSArray *acctCapGainNotItemized = [fieldPopulator acctCapitalGainNotAlreadyItemized];
		if(([fieldPopulator.itemizedAccountCapitalGain count] > 0) ||
			([acctCapGainNotItemized count] > 0))
		{
			[formPopulator nextSectionWithTitle:[NSString stringWithFormat:
				self.itemizedTaxAmtsInfo.itemSectionTitleFormat,
				LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ACCT_CAPITAL_GAIN_TITLE")]
				andHelpFile:self.itemizedTaxAmtsInfo.itemHelpInfoFile];

			for(AccountCapitalGainItemizedTaxAmt *itemizedCapGain in fieldPopulator.itemizedAccountCapitalGain )
			{
			
				ItemizedAccountCapitalGainTaxAmtCreator *itemizedCapGainCreator = [[[ItemizedAccountCapitalGainTaxAmtCreator alloc]
								initWithFormContext:parentContext
								andAcct:itemizedCapGain.account
								andLabel:itemizedCapGain.account.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctCapGainFieldEditInfo =
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:itemizedCapGainCreator
					andItemizedTaxAmt:itemizedCapGain
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctCapGainFieldEditInfo];
				
			}
			for(Account *unitemizedAcct in acctCapGainNotItemized)
			{	
				ItemizedAccountCapitalGainTaxAmtCreator *itemizedCapGainCreator =
					[[[ItemizedAccountCapitalGainTaxAmtCreator alloc] initWithFormContext:parentContext
					andAcct:unitemizedAcct
					andLabel:unitemizedAcct.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctCapGainFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc]
					initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:itemizedCapGainCreator
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctCapGainFieldEditInfo];
			}
		}
	}

	if([self.itemizedTaxAmtsInfo itemizeAccountCapitalLosses])
	{
		NSArray *acctCapLossNotItemized = [fieldPopulator acctCapitalLossNotAlreadyItemized];
		if(([fieldPopulator.itemizedAccountCapitalLoss count] > 0) ||
			([acctCapLossNotItemized count] > 0))
		{
			[formPopulator nextSectionWithTitle:[NSString stringWithFormat:
				self.itemizedTaxAmtsInfo.itemSectionTitleFormat,
				LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ACCT_CAPITAL_LOSS_TITLE")]
				andHelpFile:self.itemizedTaxAmtsInfo.itemHelpInfoFile];

			for(AccountCapitalLossItemizedTaxAmt *itemizedCapLoss in fieldPopulator.itemizedAccountCapitalLoss )
			{
				ItemizedAccountCapitalLossTaxAmtCreator *itemizedContribCreator = [[[ItemizedAccountCapitalLossTaxAmtCreator alloc]
								initWithFormContext:parentContext
								andAcct:itemizedCapLoss.account
								andLabel:itemizedCapLoss.account.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctCapLossFieldEditInfo =
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:itemizedContribCreator
					andItemizedTaxAmt:itemizedCapLoss
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctCapLossFieldEditInfo];
				
			}
			for(Account *unitemizedAcct in acctCapLossNotItemized)
			{	
				ItemizedAccountCapitalLossTaxAmtCreator *itemizedCapLossCreator =
					[[[ItemizedAccountCapitalLossTaxAmtCreator alloc] initWithFormContext:parentContext
					andAcct:unitemizedAcct
					andLabel:unitemizedAcct.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctCapLossFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc]
					initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:itemizedCapLossCreator
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctCapLossFieldEditInfo];
			}
		}
	}

	if([self.itemizedTaxAmtsInfo itemizeAccountContribs])
	{
		NSArray *acctContribNotItemized = [fieldPopulator acctContribsNotAlreadyItemized];
		if(([fieldPopulator.itemizedAccountContribs count] > 0) ||
			([acctContribNotItemized count] > 0))
		{
			[formPopulator nextSectionWithTitle:[NSString stringWithFormat:
				self.itemizedTaxAmtsInfo.itemSectionTitleFormat,
				LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ACCT_CONTRIB_TITLE")]
				andHelpFile:self.itemizedTaxAmtsInfo.itemHelpInfoFile];

			for(AccountContribItemizedTaxAmt *itemizedAcctContrib in fieldPopulator.itemizedAccountContribs )
			{
			
				ItemizedAccountContribTaxAmtCreator *itemizedContribCreator = [[[ItemizedAccountContribTaxAmtCreator alloc] 
								initWithFormContext:parentContext
								andAcct:itemizedAcctContrib.account
								andLabel:itemizedAcctContrib.account.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctContribFieldEditInfo = 
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:itemizedContribCreator
					andItemizedTaxAmt:itemizedAcctContrib
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctContribFieldEditInfo];
				
			}
			for(Account *unitemizedAcct in acctContribNotItemized)
			{	
				ItemizedAccountContribTaxAmtCreator *itemizedContribCreator = 
					[[[ItemizedAccountContribTaxAmtCreator alloc] initWithFormContext:parentContext
					andAcct:unitemizedAcct
					andLabel:unitemizedAcct.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctContribFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc] 
					initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:itemizedContribCreator
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctContribFieldEditInfo];
			}
		}
	}


	if([self.itemizedTaxAmtsInfo itemizeAccountWithdrawals])
	{
		NSArray *acctWithdrawalNotItemized = [fieldPopulator acctWithdrawalsNotAlreadyItemized];
		if(([fieldPopulator.itemizedAccountWithdrawals count] > 0) ||
			([acctWithdrawalNotItemized count] > 0))
		{
			[formPopulator nextSectionWithTitle:[NSString stringWithFormat:
				self.itemizedTaxAmtsInfo.itemSectionTitleFormat,
				LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ACCT_WITHDRAWAL_TITLE")]
				andHelpFile:self.itemizedTaxAmtsInfo.itemHelpInfoFile];

			for(AccountWithdrawalItemizedTaxAmt *itemizedAcctWithdrawal in 
						fieldPopulator.itemizedAccountWithdrawals )
			{
			
				ItemizedAccountWithdrawalTaxAmtCreator *itemizedWithdrawalCreator = 
								[[[ItemizedAccountWithdrawalTaxAmtCreator alloc] 
								initWithFormContext:parentContext 
								andAcct:itemizedAcctWithdrawal.account
								andLabel:itemizedAcctWithdrawal.account.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctWithdrawalFieldEditInfo = 
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:itemizedWithdrawalCreator
					andItemizedTaxAmt:itemizedAcctWithdrawal
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctWithdrawalFieldEditInfo];
				
			}
			for(Account *unitemizedAcct in acctWithdrawalNotItemized)
			{	
				ItemizedAccountWithdrawalTaxAmtCreator *itemizedTaxAmtCreator = 
						[[[ItemizedAccountWithdrawalTaxAmtCreator alloc] 
						initWithFormContext:parentContext 
						andAcct:unitemizedAcct andLabel:unitemizedAcct.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctWithdrawalFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc] 
					initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:itemizedTaxAmtCreator
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctWithdrawalFieldEditInfo];
			}
		}
	}

	if([self.itemizedTaxAmtsInfo itemizeAssetGains])
	{
		NSArray *assetNotItemized = [fieldPopulator assetGainsNotAlreadyItemized];
		if(([fieldPopulator.itemizedAssets count] > 0) ||
			([assetNotItemized count] > 0))
		{
			[formPopulator nextSectionWithTitle:[NSString stringWithFormat:
				self.itemizedTaxAmtsInfo.itemSectionTitleFormat,
				LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ASSET_GAIN_TITLE")]
				andHelpFile:self.itemizedTaxAmtsInfo.itemHelpInfoFile];

			for(AssetGainItemizedTaxAmt *itemizedAssetGain in fieldPopulator.itemizedAssets )
			{
				ItemizedTaxAmtFieldEditInfo *assetGainFieldEditInfo = 
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:
							[[[ItemizedAssetGainTaxAmtCreator alloc] 
								initWithFormContext:parentContext
									andAsset:itemizedAssetGain.asset
									andLabel:itemizedAssetGain.asset.name] autorelease]
					andItemizedTaxAmt:itemizedAssetGain
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:assetGainFieldEditInfo];
				
			}
			for(AssetInput *unitemizedAsset in assetNotItemized)
			{	
				ItemizedTaxAmtFieldEditInfo *assetGainFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc] 
					initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:
						[[[ItemizedAssetGainTaxAmtCreator alloc] initWithFormContext:parentContext
							andAsset:unitemizedAsset
							andLabel:unitemizedAsset.name] autorelease]
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:assetGainFieldEditInfo];
			}
		}
	}


	if([self.itemizedTaxAmtsInfo itemizeAssetLosses])
	{
		NSArray *assetNotItemized = [fieldPopulator assetLossesNotAlreadyItemized];
		if(([fieldPopulator.itemizedAssetLosses count] > 0) ||
			([assetNotItemized count] > 0))
		{
			[formPopulator nextSectionWithTitle:[NSString stringWithFormat:
				self.itemizedTaxAmtsInfo.itemSectionTitleFormat,
				LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ASSET_LOSS_TITLE")]
				andHelpFile:self.itemizedTaxAmtsInfo.itemHelpInfoFile];

			for(AssetLossItemizedTaxAmt *itemizedAssetLoss in fieldPopulator.itemizedAssetLosses )
			{
				ItemizedTaxAmtFieldEditInfo *assetLossFieldEditInfo =
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:
							[[[ItemizedAssetLossTaxAmtCreator alloc]
								initWithFormContext:parentContext
									andAsset:itemizedAssetLoss.asset
									andLabel:itemizedAssetLoss.asset.name] autorelease]
					andItemizedTaxAmt:itemizedAssetLoss
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:assetLossFieldEditInfo];
				
			}
			for(AssetInput *unitemizedAsset in assetNotItemized)
			{	
				ItemizedTaxAmtFieldEditInfo *assetLossFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc]
					initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:
						[[[ItemizedAssetLossTaxAmtCreator alloc] initWithFormContext:parentContext
							andAsset:unitemizedAsset
							andLabel:unitemizedAsset.name] autorelease]
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:assetLossFieldEditInfo];
			}
		}
	}

	
	if([self.itemizedTaxAmtsInfo itemizeLoanInterest])
	{
		NSArray *loansNotItemized = [fieldPopulator loanInterestNotAlreadyItemized];
		if(([fieldPopulator.itemizedLoans count] > 0) ||
			([loansNotItemized count] > 0))
		{
			[formPopulator nextSectionWithTitle:[NSString stringWithFormat:
				self.itemizedTaxAmtsInfo.itemSectionTitleFormat,
				LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_LOAN_INTEREST_TITLE")]
				andHelpFile:self.itemizedTaxAmtsInfo.itemHelpInfoFile];

			for(LoanInterestItemizedTaxAmt *itemizedLoan in fieldPopulator.itemizedLoans )
			{
				ItemizedTaxAmtFieldEditInfo *loanFieldEditInfo = 
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:
							[[[ItemizedLoanInterestTaxAmtCreator alloc] 
								initWithFormContext:parentContext
								andLoan:itemizedLoan.loan
								andLabel:itemizedLoan.loan.name] autorelease]
					andItemizedTaxAmt:itemizedLoan
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:loanFieldEditInfo];
				
			}
			for(LoanInput *unitemizedLoan in loansNotItemized)
			{	
				ItemizedTaxAmtFieldEditInfo *loanFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc] 
					initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:
						[[[ItemizedLoanInterestTaxAmtCreator alloc] initWithFormContext:parentContext
							andLoan:unitemizedLoan
							andLabel:unitemizedLoan.name] autorelease]
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:loanFieldEditInfo];
			}
		}
	}
	
	if([self.itemizedTaxAmtsInfo itemizeTaxesPaid])
	{
		NSArray *taxesNotItemized = [fieldPopulator 
				taxesPaidNotAlreadyItemizedExcluding:self.itemizedTaxAmtsInfo.tax];
		if(([fieldPopulator.itemizedTaxesPaid count] > 0) ||
			([taxesNotItemized count] > 0))
		{
			[formPopulator nextSectionWithTitle:[NSString stringWithFormat:
				self.itemizedTaxAmtsInfo.itemSectionTitleFormat,
				LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_TAXES_PAID_TITLE")]];
				
			for(TaxesPaidItemizedTaxAmt *itemizedTax in fieldPopulator.itemizedTaxesPaid)
			{			
				ItemizedTaxAmtFieldEditInfo *taxFieldEditInfo = 
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:
							[[[ItemizedTaxesPaidTaxAmtCreator alloc] initWithFormContext:parentContext andTax:itemizedTax.tax andLabel:itemizedTax.tax.name] autorelease]
					andItemizedTaxAmt:itemizedTax
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:taxFieldEditInfo];
			}
			for(TaxInput *unitemizedTax in taxesNotItemized)
			{
				ItemizedTaxAmtFieldEditInfo *taxFieldEditInfo = 
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithDataModelController:parentContext.dataModelController 
						andItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:
							[[[ItemizedTaxesPaidTaxAmtCreator alloc] initWithFormContext:parentContext 
								andTax:unitemizedTax andLabel:unitemizedTax.name] autorelease]
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:taxFieldEditInfo];
			}

		}
	}

	return formPopulator.formInfo;
	
}

-(void)dealloc
{
	[itemizedTaxAmtsInfo release];
	[super dealloc];
}


@end
