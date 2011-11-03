//
//  ItemizedTaxAmtSelectionFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxAmtSelectionFormInfoCreator.h"
#import "FormPopulator.h"
#import "DataModelController.h"
#import "LocalizationHelper.h"
#import "SectionInfo.h"
#import "StaticNavFieldEditInfo.h"
#import "ItemizedTableViewAddItemTableViewFactory.h"

#import "IncomeInput.h"
#import "ItemizedIncomeTaxAmtCreator.h"
#import "ExpenseInput.h"
#import "ItemizedExpenseTaxAmtCreator.h"

#import "Account.h"
#import "ItemizedAccountTaxAmtCreator.h"

#import "Account.h"
#import "ItemizedAccountContribTaxAmtCreator.h"
#import "ItemizedAccountWithdrawalTaxAmtCreator.h"

#import "AssetInput.h"
#import "ItemizedAssetGainTaxAmtCreator.h"

#import "LoanInput.h"
#import "ItemizedLoanInterestTaxAmtCreator.h"

@implementation ItemizedTaxAmtSelectionFormInfoCreator

@synthesize itemizedTaxAmtsInfo;

-(id)initWithItemizedTaxAmtsInfo:(ItemizedTaxAmtsInfo*)theItemizedTaxAmtsInfo
{
	self = [super init];
	if(self)
	{
		assert(theItemizedTaxAmtsInfo != nil);
		self.itemizedTaxAmtsInfo = theItemizedTaxAmtsInfo;
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
    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
	// TODO - Need to paramterize this title.
    formPopulator.formInfo.title = 
		LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_SOURCES_SELECTION_TITLE");
	
	SectionInfo *sectionInfo;
	
	// TODO - Need to support enabling/disabling of linking to different types of amounts,
	// and finish iterating through these different types to fully support linking.

	NSArray *inputs = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:INCOME_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_INCOMES");
		for(IncomeInput *income in inputs)
		{
			id<ItemizedTaxAmtCreator> incomeTaxAmtCreator = 
				[[[ItemizedIncomeTaxAmtCreator alloc] initWithIncome:income ] autorelease]; 
			id<GenericTableViewFactory> itemizedAddViewFactory = 
				[[[ItemizedTableViewAddItemTableViewFactory alloc] 
					initWithItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo 
					andItemizedTaxAmtCreator:incomeTaxAmtCreator] autorelease];
			StaticNavFieldEditInfo *itemizedIncomeSelectionFieldEditInfo =
				[[[StaticNavFieldEditInfo alloc] initWithCaption:income.name andSubtitle:nil andContentDescription:nil 
				andSubViewFactory:itemizedAddViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:itemizedIncomeSelectionFieldEditInfo];
		}
	}
	
	inputs = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:EXPENSE_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_EXPENSES");
		for(ExpenseInput *expense in inputs)
		{
			id<ItemizedTaxAmtCreator> expenseTaxAmtCreator = 
				[[[ItemizedExpenseTaxAmtCreator alloc] initWithExpense:expense ] autorelease]; 
			id<GenericTableViewFactory> itemizedAddViewFactory = 
				[[[ItemizedTableViewAddItemTableViewFactory alloc] 
					initWithItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo 
					andItemizedTaxAmtCreator:expenseTaxAmtCreator] autorelease];
			StaticNavFieldEditInfo *itemizedExpenseSelectionFieldEditInfo =
				[[[StaticNavFieldEditInfo alloc] initWithCaption:expense.name andSubtitle:nil andContentDescription:nil 
				andSubViewFactory:itemizedAddViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:itemizedExpenseSelectionFieldEditInfo];
		}
	}

	
	inputs = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:ACCOUNT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"ITEMIZED_TAX_ACCOUNT_INTEREST_SECTION_TITLE");
		for(Account *acct in inputs)
		{
			id<ItemizedTaxAmtCreator> savingsTaxAmtCreator = 
				[[[ItemizedAccountTaxAmtCreator alloc] initWithAcct:acct ] autorelease]; 
			id<GenericTableViewFactory> itemizedAddViewFactory = 
				[[[ItemizedTableViewAddItemTableViewFactory alloc] 
					initWithItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo 
					andItemizedTaxAmtCreator:savingsTaxAmtCreator] autorelease];
			StaticNavFieldEditInfo *itemizedSavingsSelectionFieldEditInfo =
				[[[StaticNavFieldEditInfo alloc] initWithCaption:acct.name 
				andSubtitle:nil andContentDescription:nil 
				andSubViewFactory:itemizedAddViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:itemizedSavingsSelectionFieldEditInfo];
		}
	}


	inputs = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:ACCOUNT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"ITEMIZED_TAX_ACCOUNT_CONTRIBUTIONS_SECTION_TITLE");
		for(Account *acct in inputs)
		{
			id<ItemizedTaxAmtCreator> contribTaxAmtCreator = 
				[[[ItemizedAccountContribTaxAmtCreator alloc] initWithAccount:acct ] autorelease]; 
			id<GenericTableViewFactory> itemizedAddViewFactory = 
				[[[ItemizedTableViewAddItemTableViewFactory alloc] 
					initWithItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo 
					andItemizedTaxAmtCreator:contribTaxAmtCreator] autorelease];
			StaticNavFieldEditInfo *itemizedContribSelectionFieldEditInfo =
				[[[StaticNavFieldEditInfo alloc] initWithCaption:acct.name 
					andSubtitle:nil andContentDescription:nil 
				andSubViewFactory:itemizedAddViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:itemizedContribSelectionFieldEditInfo];
		}
	}

	inputs = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:ACCOUNT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"ITEMIZED_TAX_ACCOUNT_WITHDRAWALS_SECTION_TITLE");
		for(Account *acct in inputs)
		{
			id<ItemizedTaxAmtCreator> withdrawalTaxAmtCreator = 
				[[[ItemizedAccountWithdrawalTaxAmtCreator alloc] initWithAccount:acct ] autorelease]; 
			id<GenericTableViewFactory> itemizedAddViewFactory = 
				[[[ItemizedTableViewAddItemTableViewFactory alloc] 
					initWithItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo 
					andItemizedTaxAmtCreator:withdrawalTaxAmtCreator] autorelease];
			StaticNavFieldEditInfo *itemizedWithdrawalSelectionFieldEditInfo =
				[[[StaticNavFieldEditInfo alloc] initWithCaption:acct.name 
					andSubtitle:nil andContentDescription:nil 
				andSubViewFactory:itemizedAddViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:itemizedWithdrawalSelectionFieldEditInfo];
		}
	}

	inputs = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:ASSET_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"ITEMIZED_TAX_ASSET_GAIN_SECTION_TITLE");
		for(AssetInput *asset in inputs)
		{
			id<ItemizedTaxAmtCreator> assetGainTaxAmtCreator = 
				[[[ItemizedAssetGainTaxAmtCreator alloc] initWithAsset:asset ] autorelease]; 
			id<GenericTableViewFactory> itemizedAddViewFactory = 
				[[[ItemizedTableViewAddItemTableViewFactory alloc] 
					initWithItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo 
					andItemizedTaxAmtCreator:assetGainTaxAmtCreator] autorelease];
			StaticNavFieldEditInfo *assetGainSelectionFieldEditInfo =
				[[[StaticNavFieldEditInfo alloc] initWithCaption:asset.name 
					andSubtitle:nil andContentDescription:nil 
				andSubViewFactory:itemizedAddViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:assetGainSelectionFieldEditInfo];
		}
	}

	inputs = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:LOAN_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"ITEMIZED_TAX_LOAN_INTEREST_SECTION_TITLE");
		for(LoanInput *loan in inputs)
		{
			id<ItemizedTaxAmtCreator> loanInterestTaxAmtCreator = 
				[[[ItemizedLoanInterestTaxAmtCreator alloc] initWithLoan:loan ] autorelease]; 
			id<GenericTableViewFactory> itemizedAddViewFactory = 
				[[[ItemizedTableViewAddItemTableViewFactory alloc] 
					initWithItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo 
					andItemizedTaxAmtCreator:loanInterestTaxAmtCreator] autorelease];
			StaticNavFieldEditInfo *loanInterestSelectionFieldEditInfo =
				[[[StaticNavFieldEditInfo alloc] initWithCaption:loan.name 
					andSubtitle:nil andContentDescription:nil 
				andSubViewFactory:itemizedAddViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:loanInterestSelectionFieldEditInfo];
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
