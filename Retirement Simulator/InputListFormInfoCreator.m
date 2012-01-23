//
//  InputListFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputListFormInfoCreator.h"
#import "FormPopulator.h"
#import "Input.h"
#import "DataModelController.h"
#import "InputFieldEditInfo.h"
#import "SectionInfo.h"
#import "LoanInput.h"
#import "InputListObjectAdder.h"
#import "SharedAppValues.h"
#import "IncomeInput.h"
#import "ExpenseInput.h"
#import "Scenario.h"
#import "LocalizationHelper.h"
#import "Account.h"
#import "AssetInput.h"
#import "TaxInput.h"

@implementation InputListFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] initWithParentController:parentController] autorelease];
    
    formPopulator.formInfo.title = @"Inputs";
	formPopulator.formInfo.objectAdder = [[[InputListObjectAdder alloc] init] autorelease];
	
	SectionInfo *sectionInfo;
	
	NSArray *inputs = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:INCOME_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_INCOMES");
		for(IncomeInput *income in inputs)
		{    
			assert(income != nil);
			InputFieldEditInfo *inputFieldEditInfo =
				[[[InputFieldEditInfo alloc] initWithInput:income] autorelease];
			[sectionInfo addFieldEditInfo:inputFieldEditInfo];
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
			assert(expense != nil);
			InputFieldEditInfo *inputFieldEditInfo =
				[[[InputFieldEditInfo alloc] initWithInput:expense] autorelease];
			[sectionInfo addFieldEditInfo:inputFieldEditInfo];
		}
	}
	
	inputs = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:ACCOUNT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_ACCOUNTS");
		for(Account *account in inputs)
		{    
			assert(account != nil);
			InputFieldEditInfo *inputFieldEditInfo =
				[[[InputFieldEditInfo alloc] initWithInput:account] autorelease];
			[sectionInfo addFieldEditInfo:inputFieldEditInfo];
		}
	}
	

	inputs = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:LOAN_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_LOANS");
		for(LoanInput *loan in inputs)
		{    
			assert(loan != nil);
			InputFieldEditInfo *inputFieldEditInfo =
				[[[InputFieldEditInfo alloc] initWithInput:loan] autorelease];
			[sectionInfo addFieldEditInfo:inputFieldEditInfo];
		}
	}


	inputs = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:ASSET_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_ASSETS");
		for(AssetInput *asset in inputs)
		{    
			assert(asset != nil);
			InputFieldEditInfo *inputFieldEditInfo =
				[[[InputFieldEditInfo alloc] initWithInput:asset] autorelease];
			[sectionInfo addFieldEditInfo:inputFieldEditInfo];
		}
	}


	inputs = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:TAX_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_TAXES");
		for(TaxInput *tax in inputs)
		{    
			assert(tax != nil);
			InputFieldEditInfo *inputFieldEditInfo =
				[[[InputFieldEditInfo alloc] initWithInput:tax] autorelease];
			[sectionInfo addFieldEditInfo:inputFieldEditInfo];
		}
	}


	return formPopulator.formInfo;
	
}

@end
