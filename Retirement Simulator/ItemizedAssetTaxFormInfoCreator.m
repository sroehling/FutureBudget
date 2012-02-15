//
//  ItemizedAssetTaxFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemizedAssetTaxFormInfoCreator.h"

#import "InputFormPopulator.h"
#import "AssetInput.h"
#import "DataModelController.h"
#import "TaxInput.h"
#import "AssetInput.h"
#import "LocalizationHelper.h"
#import "ItemizedTaxAmtsInfo.h"
#import "SectionInfo.h"
#import "ItemizedTaxAmtsInfo.h"
#import "ItemizedTaxAmtFieldPopulator.h"
#import "AssetGainItemizedTaxAmt.h"
#import "ItemizedAssetGainTaxAmtCreator.h"
#import "ItemizedTaxAmtFieldEditInfo.h"
#import "FormContext.h"


@implementation ItemizedAssetTaxFormInfoCreator

@synthesize asset;
@synthesize isForNewObject;

-(id)initWithAsset:(AssetInput*)theAsset andIsForNewObject:(BOOL)forNewObject
{
	self = [super init];
	if(self)
	{
		assert(theAsset != nil);
		self.asset = theAsset;
		
		self.isForNewObject = forNewObject;
	}
	return self;
}

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
	
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] 
		initForNewObject:self.isForNewObject
			andFormContext:parentContext] autorelease];
			
	formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_ASSET_TAXES_TITLE");
	
	NSSet *inputs = [parentContext.dataModelController
			fetchObjectsForEntityName:TAX_INPUT_ENTITY_NAME];
	if([inputs count] > 0)
	{
		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_ASSET_TAXABLE_GAIN_SECTION_TITLE")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxSourceInfo = [ItemizedTaxAmtsInfo taxSourceInfo:tax
				usingDataModelController:parentContext.dataModelController];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxSourceInfo 
				andTaxAmt:[taxSourceInfo.fieldPopulator findItemizedAssetGain:self.asset] 
				andTaxAmtCreator:[[[ItemizedAssetGainTaxAmtCreator alloc] 
					initWithFormContext:parentContext
					andAsset:self.asset andLabel:tax.name] autorelease]];				
		}
	}

	return formPopulator.formInfo;
	
}


-(void)dealloc
{
	[asset release];
	[super dealloc];
}


@end
