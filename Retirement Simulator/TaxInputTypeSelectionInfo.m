//
//  TaxInputTypeSelectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/28/13.
//
//

#import "TaxInputTypeSelectionInfo.h"
#import "TaxPresets.h"
#import "LocalizationHelper.h"
#import "TaxInput.h"
#import "TaxBracket.h"
#import "ItemizedTaxAmt.h"
#import "ItemizedTaxAmts.h"
#import "DataModelController.h"
#import "InputCreationHelper.h"

@implementation TaxInputTypeSelectionInfo

@synthesize presetPlistInfo;

-(void)dealloc
{
	[presetPlistInfo release];
	[super dealloc];
}

-(id)initWithInputCreationHelper:(InputCreationHelper*)theHelper 
	andDataModelController:(DataModelController*)theDataModelController
	andPresetPlistInfo:(NSDictionary*)thePresetInfo
{

	NSString *presetName = [thePresetInfo valueForKey:TAX_PRESET_PRESET_NAME_PLIST_KEY];
	assert(presetName != nil);
   
	NSString *presetDescription = [thePresetInfo valueForKey:TAX_PRESET_PRESET_DESCRIPTION_PLIST_KEY];
	assert(presetDescription != nil);
   
	NSString *imageName = [thePresetInfo valueForKey:TAX_PRESET_PRESET_IMAGE_PLIST_KEY];
	assert(imageName != nil);

	self = [super initWithInputCreationHelper:theHelper andDataModelController:theDataModelController
		andLabel:presetName andSubtitle:presetDescription
		andImageName:imageName];
	if(self)
	{
		assert(thePresetInfo != nil);
		self.presetPlistInfo = thePresetInfo;
	}
	return self;
}

-(id)initWithInputCreationHelper:(InputCreationHelper *)theHelper
	andDataModelController:(DataModelController*)theDataModelController
{
	self = [super initWithInputCreationHelper:theHelper andDataModelController:theDataModelController
		andLabel:LOCALIZED_STR(@"INPUT_LIST_NEW_UNINITIALIZED_TAX_FIELD_LABEL")
		andSubtitle:LOCALIZED_STR(@"INPUT_LIST_NEW_UNINITIALIZED_TAX_FIELD_SUBTITLE")
		andImageName:TAX_INPUT_DEFAULT_ICON_NAME];
	if(self)
	{
		self.presetPlistInfo = nil;
	}
	return self;
}

- (TaxBracket*)createTaxBracket
{
	TaxBracket *taxBracket = (TaxBracket*)[self.dataModelController
		createDataModelObject:TAX_BRACKET_ENTITY_NAME];
	taxBracket.cutoffGrowthRate = [inputCreationHelper multiScenDefaultGrowthRate];
	return taxBracket;
}

- (Input*)createInput
{
	TaxInput *newInput  = (TaxInput*)[self.dataModelController 
		createDataModelObject:TAX_INPUT_ENTITY_NAME];
		
	newInput.iconImageName = TAX_INPUT_DEFAULT_ICON_NAME;
	
	newInput.taxEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	
	newInput.exemptionAmt = [inputCreationHelper multiScenAmountWithDefault:0.0];
	newInput.stdDeductionAmt = [inputCreationHelper multiScenAmountWithDefault:0.0];
	newInput.exemptionGrowthRate = [inputCreationHelper multiScenDefaultGrowthRate];
	newInput.stdDeductionGrowthRate = [inputCreationHelper multiScenDefaultGrowthRate];
	
	newInput.itemizedAdjustments = [self.dataModelController 
		createDataModelObject:ITEMIZED_TAX_AMTS_ENTITY_NAME];
	newInput.itemizedDeductions = [self.dataModelController 
		createDataModelObject:ITEMIZED_TAX_AMTS_ENTITY_NAME];
	newInput.itemizedIncomeSources = [self.dataModelController 
		createDataModelObject:ITEMIZED_TAX_AMTS_ENTITY_NAME];
	newInput.itemizedCredits = [self.dataModelController 
		createDataModelObject:ITEMIZED_TAX_AMTS_ENTITY_NAME];

	newInput.taxBracket = [self createTaxBracket];
	
	if(self.presetPlistInfo != nil)
	{
		[TaxPresets populateTaxInputWithPresetInfo:newInput
			presetInfo:self.presetPlistInfo andDataModelController:self.dataModelController];
	}

	return newInput;
}


@end