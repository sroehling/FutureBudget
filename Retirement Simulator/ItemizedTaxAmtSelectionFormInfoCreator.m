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
#import "SavingsAccount.h"
#import "ItemizedSavingsTaxAmtCreator.h"


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
			fetchSortedObjectsWithEntityName:SAVINGS_ACCOUNT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"ITEMIZED_TAX_SAVINGS_INTEREST_SECTION_TITLE");
		for(SavingsAccount *savingsAcct in inputs)
		{
			id<ItemizedTaxAmtCreator> savingsTaxAmtCreator = 
				[[[ItemizedSavingsTaxAmtCreator alloc] initWithSavingsAcct:savingsAcct ] autorelease]; 
			id<GenericTableViewFactory> itemizedAddViewFactory = 
				[[[ItemizedTableViewAddItemTableViewFactory alloc] 
					initWithItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo 
					andItemizedTaxAmtCreator:savingsTaxAmtCreator] autorelease];
			StaticNavFieldEditInfo *itemizedSavingsSelectionFieldEditInfo =
				[[[StaticNavFieldEditInfo alloc] initWithCaption:savingsAcct.name andSubtitle:nil andContentDescription:nil 
				andSubViewFactory:itemizedAddViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:itemizedSavingsSelectionFieldEditInfo];
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
