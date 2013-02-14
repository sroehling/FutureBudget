//
//  InputTypeSelectionFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/13/13.
//
//

#import "InputTypeSelectionFormInfoCreator.h"
#import "FormPopulator.h"
#import "LocalizationHelper.h"
#import "FormInfo.h"
#import "VariableHeightTableHeader.h"
#import "InputCreationHelper.h"
#import "SharedAppValues.h"
#import "InputTypeSelectionInfo.h"
#import "DataModelController.h"
#import "InputTypeSelectionFieldEditInfo.h"
#import "SectionInfo.h"

#import "AssetInput.h"
#import "IncomeInput.h"
#import "ExpenseInput.h"
#import "LoanInput.h"
#import "TaxInput.h"
#import "TransferInput.h"
#import "Account.h"

@implementation InputTypeSelectionFormInfoCreator

@synthesize dmcForNewInputs;

-(id)initWithDmcForNewInputs:(DataModelController*)theDmcForNewInputs
{
	self = [super init];
	if(self)
	{
		self.dmcForNewInputs = theDmcForNewInputs;
	}
	return self;
}

- (void)dealloc
{
	[dmcForNewInputs release];
     [super dealloc];
}

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] 
		initWithFormContext:parentContext] autorelease];
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_LIST_NEW_INPUT_TITLE");
	
	
	VariableHeightTableHeader *tableHeader = 
		[[[VariableHeightTableHeader alloc] initWithFrame:CGRectZero] autorelease];
	tableHeader.header.text = LOCALIZED_STR(@"INPUT_LIST_NEW_INPUT_TABLE_TITLE");
	tableHeader.subHeader.text = LOCALIZED_STR(@"INPUT_LIST_NEW_INPUT_TABLE_SUBTITLE");
	[tableHeader resizeForChildren];
	formPopulator.formInfo.headerView = tableHeader;
	
		
	InputCreationHelper *inputCreationHelper =
		[[[InputCreationHelper alloc] 
		initWithDataModelInterface:dmcForNewInputs andSharedAppVals:
			[SharedAppValues getUsingDataModelController:self.dmcForNewInputs]]
		autorelease];
		
	[formPopulator nextSection];
    
    InputTypeSelectionInfo *typeInfo = [[[IncomeInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:inputCreationHelper 
		andDataModelInterface:dmcForNewInputs
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_INCOME_TITLE")
		andSubtitle:LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_INCOME_SUBTITLE")
		andImageName:INCOME_INPUT_DEFAULT_ICON_NAME] autorelease];
 	InputTypeSelectionFieldEditInfo *inputFieldInfo =
		[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:typeInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:inputFieldInfo];
    
    typeInfo = [[[ExpenseInputTypeSelectionInfo alloc] 
		initWithInputCreationHelper:inputCreationHelper 
		andDataModelInterface:dmcForNewInputs
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_EXPENSE_TITLE") andSubtitle:LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_EXPENSE_SUBTITLE")
		andImageName:EXPENSE_INPUT_DEFAULT_ICON_NAME] autorelease];
 	inputFieldInfo =
		[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:typeInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:inputFieldInfo];


	typeInfo = [[[TransferInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:inputCreationHelper 
		andDataModelInterface:dmcForNewInputs
		andLabel:LOCALIZED_STR(@"INPUT_TYPE_TRANSFER_TITLE")
		andSubtitle:LOCALIZED_STR(@"INPUT_TYPE_TRANSFER_SUBTITLE")
		andImageName:TRANSFER_INPUT_DEFAULT_ICON_NAME] autorelease];
	inputFieldInfo =
		[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:typeInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:inputFieldInfo]; 
	
	typeInfo = [[[SavingsAccountTypeSelectionInfo alloc]
		initWithInputCreationHelper:inputCreationHelper 
		andDataModelInterface:dmcForNewInputs
		andLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_TITLE")
		andSubtitle:LOCALIZED_STR(@"INPUT_ACCOUNT_SUBTITLE")
		andImageName:ACCOUNT_INPUT_DEFAULT_ICON_NAME] autorelease];
	inputFieldInfo =
		[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:typeInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:inputFieldInfo];

	typeInfo = [[[LoanInputTypeSelctionInfo alloc]
		initWithInputCreationHelper:inputCreationHelper 
		andDataModelInterface:dmcForNewInputs
		andLabel:LOCALIZED_STR(@"INPUT_LOAN_TITLE")
		andSubtitle:LOCALIZED_STR(@"INPUT_LOAN_SUBTITLE")
		andImageName:LOAN_INPUT_DEFAULT_ICON_NAME] autorelease];
	inputFieldInfo =
		[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:typeInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:inputFieldInfo];   


	typeInfo = [[[AssetInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:inputCreationHelper 
		andDataModelInterface:dmcForNewInputs
		andLabel:LOCALIZED_STR(@"INPUT_ASSET_TITLE")
		andSubtitle:LOCALIZED_STR(@"INPUT_ASSET_SUBTITLE")
		andImageName:ASSET_INPUT_DEFAULT_ICON_NAME] autorelease];
	inputFieldInfo =
		[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:typeInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:inputFieldInfo];   


	typeInfo = [[[TaxInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:inputCreationHelper 
		andDataModelInterface:dmcForNewInputs andLabel:LOCALIZED_STR(@"INPUT_TAX_TITLE")
		andSubtitle:LOCALIZED_STR(@"INPUT_TAX_SUBTITLE")
		andImageName:TAX_INPUT_DEFAULT_ICON_NAME] autorelease];
	inputFieldInfo =
		[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:typeInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:inputFieldInfo];
	
	
    return formPopulator.formInfo;
}


@end
