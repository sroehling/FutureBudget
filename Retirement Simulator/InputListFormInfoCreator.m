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
#import "AppHelper.h"
#import "TableHeaderWithDisclosure.h"
#import "InputTag.h"
#import "StringValidation.h"
#import "CollectionHelper.h"

@implementation InputListFormInfoCreator

@synthesize headerDelegate;
@synthesize tableHeader;

-(void)dealloc
{
	[tableHeader release];
	[super dealloc];
}

-(id)init
{
	self = [super init];
	if(self)
	{
		self.tableHeader = [[[TableHeaderWithDisclosure alloc]
			initWithFrame:CGRectZero andDisclosureButtonDelegate:self] autorelease];
		self.tableHeader.backgroundColor = [UIColor grayColor];
		[tableHeader configureWithCustomButtonImage:@"search.png"];
	}
	return self;
}

-(void)configureHeader:(DataModelController*)dataModelController
{
	SharedAppValues *sharedAppVals = [SharedAppValues getUsingDataModelController:dataModelController];
	NSString *tagsHeader = @"";
	NSString *tagsSubHeader =  @"";
	
	if(![AppHelper generatingLaunchScreen])
	{
		if(sharedAppVals.filteredTags.count > 0)
		{
		
			NSArray *sortedTags = [CollectionHelper setToSortedArray:sharedAppVals.filteredTags withKey:INPUT_TAG_NAME_KEY];
			NSMutableArray *filteredTagNames = [[[NSMutableArray alloc] init] autorelease];
			for(InputTag *filteredTag in sortedTags)
			{
				[filteredTagNames addObject:filteredTag.tagName];
			}
			
			
			tagsHeader = LOCALIZED_STR(@"INPUT_LIST_TAGS_HEADER_FILTERED_INPUTS");
			
			if(sharedAppVals.filteredTags.count > 1)
			{
				// If matching against more than one tag, then show a prefix before the
				// last tag indicating what kind of matching is done on the list of tags.
				// Currently, an input can match any of the tags to be in the input
				// list (boolean OR), so an "or" is shown before the last tag name.
				NSString *lastMatchingTag = (NSString*)[filteredTagNames lastObject];
				NSString *lastTagWithMatchTypePrefix =
					[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_LIST_TAGS_HEADER_MATCH_ANY_TAG_FORMAT"),lastMatchingTag];
				[filteredTagNames removeLastObject];
				[filteredTagNames addObject:lastTagWithMatchTypePrefix];
			}
			
			if(sharedAppVals.filteredTags.count > 2)
			{
				tagsSubHeader = [filteredTagNames componentsJoinedByString:@", "];
			}
			else
			{
				tagsSubHeader = [filteredTagNames componentsJoinedByString:@" "];
			}
			
			
		}
		else
		{
			tagsHeader = LOCALIZED_STR(@"INPUT_LIST_TAGS_HEADER_ALL_INPUTS");
			tagsSubHeader = @"";
		}
	}

	tableHeader.header.text = tagsHeader;
	tableHeader.subTitle.text = tagsSubHeader;
	[tableHeader resizeForChildren];

}

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{

	FormPopulator *formPopulator = [[[FormPopulator alloc]
		initWithFormContext:parentContext] autorelease];
		
	// Make a list of the tags currently being filtered
	[self configureHeader:parentContext.dataModelController];
	formPopulator.formInfo.headerView = self.tableHeader;

		
	if([AppHelper generatingLaunchScreen])
	{
		// If generating the launch screen, return an empty list.
		formPopulator.formInfo.title = @" ";
		formPopulator.formInfo.showEditButton = FALSE;
		return formPopulator.formInfo;
	}
	
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_LIST_TITLE");
	formPopulator.formInfo.objectAdder = [[[InputListObjectAdder alloc] init] autorelease];
	
	if([parentContext.dataModelController countObjectsForEntityName:INPUT_ENTITY_NAME] == 0)
	{
		// Only include an empty list popover when/if there are no inputs. Otherwise, the
		// table view will show the popup not only in cases where there are no inputs, but
		// also when there are inputs but none are shown because they don't match the current tag.
		formPopulator.formInfo.addButtonPopoverInfo = [[[HelpPagePopoverCaptionInfo alloc] initWithPopoverCaption:
			LOCALIZED_STR(@"INPUT_LIST_EMPTY_LIST_ADD_BUTTON_CAPTION") 
			andHelpPageMoreInfoCaption:LOCALIZED_STR(@"INPUT_LIST_EMPTY_LIST_ADD_BUTTON_MORE_INFO_CAPTION") 
			andHelpPageName:@"gettingStarted" 
			andParentController:parentContext.parentController] autorelease];
	}
	
	SectionInfo *sectionInfo;
	
	SharedAppValues *sharedAppVals = [SharedAppValues
		getUsingDataModelController:parentContext.dataModelController];
	NSPredicate *showInputPredicate;
	if(sharedAppVals.filteredTags.count > 0)
	{
		showInputPredicate = [NSPredicate predicateWithFormat:@"ANY %K IN %@",
			INPUT_TAGS_KEY,sharedAppVals.filteredTags];
	}
	else
	{
		showInputPredicate = [NSPredicate predicateWithValue:TRUE]; // Match all inputs
	}

	
	NSArray *inputs = [parentContext.dataModelController
			fetchObjectsForEntityName:INCOME_INPUT_ENTITY_NAME
			andPredicate:showInputPredicate andSortKey:INPUT_NAME_KEY andSortAscending:TRUE];
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
			fetchObjectsForEntityName:EXPENSE_INPUT_ENTITY_NAME
			andPredicate:showInputPredicate andSortKey:INPUT_NAME_KEY andSortAscending:TRUE];
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
			fetchObjectsForEntityName:TRANSFER_INPUT_ENTITY_NAME
			andPredicate:showInputPredicate andSortKey:INPUT_NAME_KEY andSortAscending:TRUE];
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
			fetchObjectsForEntityName:ACCOUNT_ENTITY_NAME
			andPredicate:showInputPredicate andSortKey:INPUT_NAME_KEY andSortAscending:TRUE];
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
			fetchObjectsForEntityName:LOAN_INPUT_ENTITY_NAME
			andPredicate:showInputPredicate andSortKey:INPUT_NAME_KEY andSortAscending:TRUE];
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
			fetchObjectsForEntityName:ASSET_INPUT_ENTITY_NAME
			andPredicate:showInputPredicate andSortKey:INPUT_NAME_KEY andSortAscending:TRUE];
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
			fetchObjectsForEntityName:TAX_INPUT_ENTITY_NAME
			andPredicate:showInputPredicate andSortKey:INPUT_NAME_KEY andSortAscending:TRUE];
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

- (void)tableHeaderDisclosureButtonPressed
{
	NSLog(@"Input Filter button pressed");
	if(self.headerDelegate != nil)
	{
		[self.headerDelegate inputListHeaderFilterTagsButtonPressed];
	}
}

// Show the input list using a plain table style
-(UITableViewStyle)tableViewStyle
{
	return UITableViewStylePlain;
}

@end
