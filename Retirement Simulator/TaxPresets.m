//
//  TaxPresets.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/26/13.
//
//

#import "TaxPresets.h"
#import "TaxInput.h"
#import "TaxBracketEntry.h"
#import "TaxBracket.h"
#import "DataModelController.h"

NSString *const TAX_PRESET_PRESET_NAME_PLIST_KEY = @"PRESET_NAME";
NSString *const TAX_PRESET_PRESET_DESCRIPTION_PLIST_KEY = @"PRESET_DESCRIPTION";
NSString *const TAX_PRESET_PRESET_IMAGE_PLIST_KEY = @"PRESET_IMAGE_NAME";

static NSString *const TAX_PRESETS_PLIST_FILE_NAME = @"TaxPresets";

static NSString *const TAX_BRACKET_PLIST_KEY = @"TAX_BRACKET";
static NSString *const TAX_BRACKET_ENTRY_TAX_PERCENT_PLIST_KEY = @"TAX_PERCENT";
static NSString *const TAX_BRACKET_ENTRY_CUTOFF_AMOUNT_PLIST_KEY = @"CUTOFF_AMOUNT";

@implementation TaxPresets

+(NSArray*)loadPresetList
{
	NSLog(@"Loading Presets");
	
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:TAX_PRESETS_PLIST_FILE_NAME ofType:@"plist"];
	
	NSArray *presetList = [[[NSArray alloc] initWithContentsOfFile:plistPath] autorelease];
	assert(presetList != nil);
	assert(presetList.count >0);
	
	return presetList;
	
	for (NSDictionary *preset in presetList) {
 		   		   
    }
}

+(void)populateTaxInputWithPresetInfo:(TaxInput*)taxInput presetInfo:(NSDictionary*)presetPlistInfo
	andDataModelController:(DataModelController*)dmcForPresetInputCreation
{
	NSString *presetName = [presetPlistInfo valueForKey:TAX_PRESET_PRESET_NAME_PLIST_KEY];
	assert(presetName != nil);
	NSLog(@"Preset: Name =  %@",presetName);
	taxInput.name = presetName;
 
	NSString *presetDescription = [presetPlistInfo valueForKey:TAX_PRESET_PRESET_DESCRIPTION_PLIST_KEY];
	assert(presetDescription != nil);
	taxInput.notes = presetDescription;
	
	
	NSString *imageName = [presetPlistInfo valueForKey:TAX_PRESET_PRESET_IMAGE_PLIST_KEY];
	assert(imageName != nil);
	taxInput.iconImageName = imageName;
	
 
	NSArray *taxBracketEntries = [presetPlistInfo objectForKey:TAX_BRACKET_PLIST_KEY];
	for(NSDictionary *taxBracketEntry in taxBracketEntries)
	{
		NSNumber *cutoffAmount = [taxBracketEntry valueForKey:TAX_BRACKET_ENTRY_CUTOFF_AMOUNT_PLIST_KEY];
		NSNumber *percentTax = [taxBracketEntry valueForKey:TAX_BRACKET_ENTRY_TAX_PERCENT_PLIST_KEY];
		
		TaxBracketEntry *presetTaxBracketEntry = [dmcForPresetInputCreation insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
		presetTaxBracketEntry.cutoffAmount = cutoffAmount;
		presetTaxBracketEntry.taxPercent = percentTax;
	
		[taxInput.taxBracket addTaxBracketEntriesObject:presetTaxBracketEntry];

		NSLog(@"Tax Bracket Entry: cutoff amt = %0.2f perc tax = %0.0f",
			[cutoffAmount doubleValue],[percentTax doubleValue]);
	}

}



@end
