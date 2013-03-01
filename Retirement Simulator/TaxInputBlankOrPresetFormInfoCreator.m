//
//  TaxInputBlankOrPresetFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/26/13.
//
//

#import "TaxInputBlankOrPresetFormInfoCreator.h"
#import "LocalizationHelper.h"
#import "FormInfo.h"
#import "VariableHeightTableHeader.h"
#import "FormPopulator.h"
#import "InputCreationHelper.h"
#import "TaxPresets.h"
#import "TaxInputTypeSelectionInfo.h"
#import "InputTypeSelectionFieldEditInfo.h"
#import "TaxInput.h"
#import "SectionInfo.h"
#import "FormContext.h"
#import "SharedAppValues.h"
#import "DataModelController.h"
#import "TaxPresets.h"

@implementation TaxInputBlankOrPresetFormInfoCreator

@synthesize inputCreationHelper;
@synthesize taxInputPresetsPlistInfo;

-(void)dealloc
{
	[inputCreationHelper release];
	[taxInputPresetsPlistInfo release];
	[super dealloc];
}

-(id)initWithInputCreationHelper:(InputCreationHelper*)theInputCreationHelper
{
	self = [super init];
	if(self)
	{
		assert(theInputCreationHelper != nil);
		self.inputCreationHelper = theInputCreationHelper;
		
		self.taxInputPresetsPlistInfo = [TaxPresets loadPresetList];
	}
	return self;
}

-(id)init
{
	assert(0);
}

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] 
		initWithFormContext:parentContext] autorelease];
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_LIST_NEW_TAX_INPUT_TITLE");
	
	
	VariableHeightTableHeader *tableHeader = 
		[[[VariableHeightTableHeader alloc] initWithFrame:CGRectZero] autorelease];
	tableHeader.header.text = LOCALIZED_STR(@"INPUT_LIST_NEW_TAX_INPUT_TABLE_TITLE");
	tableHeader.subHeader.text = LOCALIZED_STR(@"INPUT_LIST_NEW_TAX_INPUT_TABLE_SUBTITLE");
	[tableHeader resizeForChildren];
	formPopulator.formInfo.headerView = tableHeader;
	
	

	[formPopulator nextSection];
    	
	InputTypeSelectionInfo *typeInfo = [[[TaxInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:self.inputCreationHelper
		andDataModelController:self.inputCreationHelper.dataModel] autorelease];
	InputTypeSelectionFieldEditInfo *inputFieldInfo =
		[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:typeInfo] autorelease];
	[formPopulator.currentSection addFieldEditInfo:inputFieldInfo];
	
	
	// Section for selecting a preset tax instead of a blank one.
	
	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"TAX_PRESET_SECTION_HEADER")
		andHelpFile:@"taxPresets" ];
	
	for (NSDictionary *presetInfo in self.taxInputPresetsPlistInfo)
	{
		InputTypeSelectionInfo *presetTypeInfo = [[[TaxInputTypeSelectionInfo alloc]
			initWithInputCreationHelper:self.inputCreationHelper
			andDataModelController:self.inputCreationHelper.dataModel andPresetPlistInfo:presetInfo] autorelease];
		InputTypeSelectionFieldEditInfo *presetInputFieldInfo =
			[[[InputTypeSelectionFieldEditInfo alloc] initWithTypeSelectionInfo:presetTypeInfo] autorelease];
		[formPopulator.currentSection addFieldEditInfo:presetInputFieldInfo];
	}

	
    return formPopulator.formInfo;
}



@end
