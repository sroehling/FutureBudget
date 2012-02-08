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
#import "LocalizationHelper.h"

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



- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
	
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] 
		initForNewObject:self.isForNewObject
			andParentController:parentController] autorelease];
    
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
				andHelpFile:self.itemizedTaxAmtsInfo.itemHelpInfoFile];

			for(IncomeItemizedTaxAmt *itemizedIncome in fieldPopulator.itemizedIncomes )
			{
				// TODO - Migrate the code below (and other instances in this file) to use
				// the formPopulator's "populate" selector for itemized tax amounts.
				ItemizedIncomeTaxAmtCreator *itemCreator = [[[ItemizedIncomeTaxAmtCreator alloc] 
						initWithIncome:itemizedIncome.income 
						andItemLabel:itemizedIncome.income.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *incomeFieldEditInfo = 
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:itemCreator
					andItemizedTaxAmt:itemizedIncome
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:incomeFieldEditInfo];
				
			}
			for(IncomeInput *unitemizedIncome in incomesNotItemized)
			{	
				ItemizedIncomeTaxAmtCreator *itemCreator = [[[ItemizedIncomeTaxAmtCreator alloc] 
						initWithIncome:unitemizedIncome 
						andItemLabel:unitemizedIncome.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *incomeFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc] 
					initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
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
						initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:
							[[[ItemizedExpenseTaxAmtCreator alloc] 
								initWithExpense:itemizedExpense.expense andLabel:itemizedExpense.expense.name] autorelease]
					andItemizedTaxAmt:itemizedExpense
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:expenseFieldEditInfo];
			}
			for(ExpenseInput *unitemizedExpense in expensesNotItemized)
			{	
				ItemizedTaxAmtFieldEditInfo *expenseFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc] 
					initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:
						[[[ItemizedExpenseTaxAmtCreator alloc] 
						initWithExpense:unitemizedExpense andLabel:unitemizedExpense.name] autorelease]
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
								initWithAcct:itemizedAcctInterest.account 
								andLabel:itemizedAcctInterest.account.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctInterestFieldEditInfo = 
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:itemizedAcctTaxInterestCreator
					andItemizedTaxAmt:itemizedAcctInterest
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctInterestFieldEditInfo];
				
			}
			for(Account *unitemizedAcct in acctInterestNotItemized)
			{	
				ItemizedAccountTaxAmtCreator *itemizedAcctTaxInterestCreator = 
					[[[ItemizedAccountTaxAmtCreator alloc] initWithAcct:unitemizedAcct
						andLabel:unitemizedAcct.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctInterestFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc] 
					initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:itemizedAcctTaxInterestCreator
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctInterestFieldEditInfo];
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
								initWithAcct:itemizedAcctContrib.account
								andLabel:itemizedAcctContrib.account.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctContribFieldEditInfo = 
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:itemizedContribCreator
					andItemizedTaxAmt:itemizedAcctContrib
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctContribFieldEditInfo];
				
			}
			for(Account *unitemizedAcct in acctContribNotItemized)
			{	
				ItemizedAccountContribTaxAmtCreator *itemizedContribCreator = 
					[[[ItemizedAccountContribTaxAmtCreator alloc] initWithAcct:unitemizedAcct
					andLabel:unitemizedAcct.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctContribFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc] 
					initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
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
								initWithAcct:itemizedAcctWithdrawal.account
								andLabel:itemizedAcctWithdrawal.account.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctWithdrawalFieldEditInfo = 
					[[[ItemizedTaxAmtFieldEditInfo alloc] 
						initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:itemizedWithdrawalCreator
					andItemizedTaxAmt:itemizedAcctWithdrawal
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:acctWithdrawalFieldEditInfo];
				
			}
			for(Account *unitemizedAcct in acctWithdrawalNotItemized)
			{	
				ItemizedAccountWithdrawalTaxAmtCreator *itemizedTaxAmtCreator = 
						[[[ItemizedAccountWithdrawalTaxAmtCreator alloc] 
						initWithAcct:unitemizedAcct andLabel:unitemizedAcct.name] autorelease];
				ItemizedTaxAmtFieldEditInfo *acctWithdrawalFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc] 
					initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
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
						initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:
							[[[ItemizedAssetGainTaxAmtCreator alloc] 
								initWithAsset:itemizedAssetGain.asset andLabel:itemizedAssetGain.asset.name] autorelease]
					andItemizedTaxAmt:itemizedAssetGain
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:assetGainFieldEditInfo];
				
			}
			for(AssetInput *unitemizedAsset in assetNotItemized)
			{	
				ItemizedTaxAmtFieldEditInfo *assetGainFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc] 
					initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:
						[[[ItemizedAssetGainTaxAmtCreator alloc] initWithAsset:unitemizedAsset
							andLabel:unitemizedAsset.name] autorelease]
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:assetGainFieldEditInfo];
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
						initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
						andItemizedTaxAmtCreator:
							[[[ItemizedLoanInterestTaxAmtCreator alloc] 
								initWithLoan:itemizedLoan.loan
								andLabel:itemizedLoan.loan.name] autorelease]
					andItemizedTaxAmt:itemizedLoan
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:loanFieldEditInfo];
				
			}
			for(LoanInput *unitemizedLoan in loansNotItemized)
			{	
				ItemizedTaxAmtFieldEditInfo *loanFieldEditInfo = [[[ItemizedTaxAmtFieldEditInfo alloc] 
					initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts 
					andItemizedTaxAmtCreator:
						[[[ItemizedLoanInterestTaxAmtCreator alloc] initWithLoan:unitemizedLoan
							andLabel:unitemizedLoan.name] autorelease]
					andItemizedTaxAmt:nil
					andItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo andIsForNewObject:self.isForNewObject] autorelease];
				[formPopulator.currentSection addFieldEditInfo:loanFieldEditInfo];
			}
		}
	}

	return formPopulator.formInfo;
	
}

-(void)dealloc
{
	[super dealloc];
	[itemizedTaxAmtsInfo release];
}


@end
