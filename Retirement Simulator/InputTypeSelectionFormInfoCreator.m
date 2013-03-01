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
#import "TaxPresets.h"
#import "TransferInput.h"
#import "Account.h"

#import "TaxInputBlankOrPresetFormInfoCreator.h"
#import "SelectableObjectCreationTableViewFactory.h"
#import "StaticNavFieldEditInfo.h"

@implementation InputTypeSelectionFormInfoCreator

@synthesize dmcForNewInputs;
@synthesize inputSelectedForCreationDelegate;
@synthesize inputCreationHelper;

-(id)initWithDmcForNewInputs:(DataModelController*)theDmcForNewInputs
	andInputSelectedForCreationDelegate:(id<ObjectSelectedForCreationDelegate>)theInputSelectedForCreationDelegate
{
	self = [super init];
	if(self)
	{
		self.dmcForNewInputs = theDmcForNewInputs;
		
		self.inputCreationHelper =
		[[[InputCreationHelper alloc] 
		initWithDataModelController:dmcForNewInputs andSharedAppVals:
			[SharedAppValues getUsingDataModelController:self.dmcForNewInputs]]
		autorelease];

		
		assert(theInputSelectedForCreationDelegate != nil);
		self.inputSelectedForCreationDelegate = theInputSelectedForCreationDelegate;
	}
	return self;
}

- (void)dealloc
{
	[dmcForNewInputs release];
	[inputCreationHelper release];
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
	
		
		
	[formPopulator nextSection];
    
    InputTypeSelectionInfo *typeInfo = [[[IncomeInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:self.inputCreationHelper
		andDataModelController:dmcForNewInputs
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_INCOME_TITLE")
		andSubtitle:LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_INCOME_SUBTITLE")
		andImageName:INCOME_INPUT_DEFAULT_ICON_NAME] autorelease];
 	InputTypeSelectionFieldEditInfo *inputFieldInfo =
		[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:typeInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:inputFieldInfo];
    
    typeInfo = [[[ExpenseInputTypeSelectionInfo alloc] 
		initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:dmcForNewInputs
		andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_EXPENSE_TITLE") andSubtitle:LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_EXPENSE_SUBTITLE")
		andImageName:EXPENSE_INPUT_DEFAULT_ICON_NAME] autorelease];
 	inputFieldInfo =
		[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:typeInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:inputFieldInfo];


	typeInfo = [[[TransferInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:dmcForNewInputs
		andLabel:LOCALIZED_STR(@"INPUT_TYPE_TRANSFER_TITLE")
		andSubtitle:LOCALIZED_STR(@"INPUT_TYPE_TRANSFER_SUBTITLE")
		andImageName:TRANSFER_INPUT_DEFAULT_ICON_NAME] autorelease];
	inputFieldInfo =
		[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:typeInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:inputFieldInfo]; 
	
	typeInfo = [[[SavingsAccountTypeSelectionInfo alloc]
		initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:dmcForNewInputs
		andLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_TITLE")
		andSubtitle:LOCALIZED_STR(@"INPUT_ACCOUNT_SUBTITLE")
		andImageName:ACCOUNT_INPUT_DEFAULT_ICON_NAME] autorelease];
	inputFieldInfo =
		[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:typeInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:inputFieldInfo];

	typeInfo = [[[LoanInputTypeSelctionInfo alloc]
		initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:dmcForNewInputs
		andLabel:LOCALIZED_STR(@"INPUT_LOAN_TITLE")
		andSubtitle:LOCALIZED_STR(@"INPUT_LOAN_SUBTITLE")
		andImageName:LOAN_INPUT_DEFAULT_ICON_NAME] autorelease];
	inputFieldInfo =
		[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:typeInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:inputFieldInfo];   


	typeInfo = [[[AssetInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:dmcForNewInputs
		andLabel:LOCALIZED_STR(@"INPUT_ASSET_TITLE")
		andSubtitle:LOCALIZED_STR(@"INPUT_ASSET_SUBTITLE")
		andImageName:ASSET_INPUT_DEFAULT_ICON_NAME] autorelease];
	inputFieldInfo =
		[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:typeInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:inputFieldInfo];   


	// For the tax input, a second level of selection is done to pick either
	// a blank/un-initialized tax input, or select to populate with a
	// preset.
	TaxInputBlankOrPresetFormInfoCreator *taxInputSelectionFormInfoCreator =
		[[[TaxInputBlankOrPresetFormInfoCreator alloc]
		initWithInputCreationHelper:self.inputCreationHelper] autorelease];
	 SelectableObjectCreationTableViewFactory *taxInputSelectionViewFactory =
		[[[SelectableObjectCreationTableViewFactory alloc]
		initWithObjectSelectionCreationDelegate:self.inputSelectedForCreationDelegate
		andFormInfoCreator:taxInputSelectionFormInfoCreator] autorelease];
	StaticNavFieldEditInfo *taxInputFieldEditInfo =
		[[[StaticNavFieldEditInfo alloc] 
			initWithCaption:LOCALIZED_STR(@"INPUT_TAX_TITLE")
			andSubtitle:LOCALIZED_STR(@"INPUT_TAX_SUBTITLE") 
			andContentDescription:nil
			andSubViewFactory:taxInputSelectionViewFactory] autorelease];
	taxInputFieldEditInfo.valueCell.imageView.image = [UIImage imageNamed:TAX_INPUT_DEFAULT_ICON_NAME];
	[formPopulator.currentSection addFieldEditInfo:taxInputFieldEditInfo];		
	
	
    return formPopulator.formInfo;
}


@end
