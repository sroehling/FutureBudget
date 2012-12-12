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
#import "TransferInput.h"

#import "HelpPagePopoverCaptionInfo.h"
#import "FormContext.h"

@implementation InputListFormInfoCreator

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{

	FormPopulator *formPopulator = [[[FormPopulator alloc]
		initWithFormContext:parentContext] autorelease];
		
    
    formPopulator.formInfo.title = @"Inputs";
	formPopulator.formInfo.objectAdder = [[[InputListObjectAdder alloc] init] autorelease];
	
	formPopulator.formInfo.addButtonPopoverInfo = [[[HelpPagePopoverCaptionInfo alloc] initWithPopoverCaption:
		LOCALIZED_STR(@"INPUT_LIST_EMPTY_LIST_ADD_BUTTON_CAPTION") 
		andHelpPageMoreInfoCaption:LOCALIZED_STR(@"INPUT_LIST_EMPTY_LIST_ADD_BUTTON_MORE_INFO_CAPTION") 
		andHelpPageName:@"gettingStarted" 
		andParentController:parentContext.parentController] autorelease];
	
	SectionInfo *sectionInfo;
	
	NSArray *inputs = [parentContext.dataModelController
			fetchSortedObjectsWithEntityName:INCOME_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_INCOMES");
		for(IncomeInput *income in inputs)
		{    
			assert(income != nil);
			InputFieldEditInfo *inputFieldEditInfo =
				[[[InputFieldEditInfo alloc] initWithInput:income andDataModelController:parentContext.dataModelController] autorelease];
			[sectionInfo addFieldEditInfo:inputFieldEditInfo];
		}
	}

	inputs = [parentContext.dataModelController
			fetchSortedObjectsWithEntityName:EXPENSE_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_EXPENSES");
		for(ExpenseInput *expense in inputs)
		{    
			assert(expense != nil);
			InputFieldEditInfo *inputFieldEditInfo =
				[[[InputFieldEditInfo alloc] initWithInput:expense andDataModelController:parentContext.dataModelController] autorelease];
			[sectionInfo addFieldEditInfo:inputFieldEditInfo];
		}
	}
	
	inputs = [parentContext.dataModelController
			fetchSortedObjectsWithEntityName:TRANSFER_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_TRANSFER")];
		for(TransferInput *transfer in inputs)
		{    
			assert(transfer != nil);
			InputFieldEditInfo *inputFieldEditInfo =
				[[[InputFieldEditInfo alloc] initWithInput:transfer 
					andDataModelController:parentContext.dataModelController] autorelease];
			[sectionInfo addFieldEditInfo:inputFieldEditInfo];
		}
	}

	
	
	inputs = [parentContext.dataModelController
			fetchSortedObjectsWithEntityName:ACCOUNT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_ACCOUNTS");
		for(Account *account in inputs)
		{    
			assert(account != nil);
			InputFieldEditInfo *inputFieldEditInfo =
				[[[InputFieldEditInfo alloc] initWithInput:account andDataModelController:parentContext.dataModelController] autorelease];
			[sectionInfo addFieldEditInfo:inputFieldEditInfo];
		}
	}
	

	inputs = [parentContext.dataModelController
			fetchSortedObjectsWithEntityName:LOAN_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_LOANS");
		for(LoanInput *loan in inputs)
		{    
			assert(loan != nil);
			InputFieldEditInfo *inputFieldEditInfo =
				[[[InputFieldEditInfo alloc] initWithInput:loan andDataModelController:parentContext.dataModelController] autorelease];
			[sectionInfo addFieldEditInfo:inputFieldEditInfo];
		}
	}


	inputs = [parentContext.dataModelController
			fetchSortedObjectsWithEntityName:ASSET_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_ASSETS");
		for(AssetInput *asset in inputs)
		{    
			assert(asset != nil);
			InputFieldEditInfo *inputFieldEditInfo =
				[[[InputFieldEditInfo alloc] initWithInput:asset andDataModelController:parentContext.dataModelController] autorelease];
			[sectionInfo addFieldEditInfo:inputFieldEditInfo];
		}
	}


	inputs = [parentContext.dataModelController
			fetchSortedObjectsWithEntityName:TAX_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_TAXES");
		for(TaxInput *tax in inputs)
		{    
			assert(tax != nil);
			InputFieldEditInfo *inputFieldEditInfo =
				[[[InputFieldEditInfo alloc] initWithInput:tax andDataModelController:parentContext.dataModelController] autorelease];
			[sectionInfo addFieldEditInfo:inputFieldEditInfo];
		}
	}

	return formPopulator.formInfo;
	
}

// Show the input list using a plain table style
-(UITableViewStyle)tableViewStyle
{
	return UITableViewStylePlain;
}

@end
