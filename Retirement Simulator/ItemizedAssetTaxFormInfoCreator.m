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

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
	
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] 
		initForNewObject:self.isForNewObject
			andParentController:parentController] autorelease];
			
	formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_ASSET_TAXES_TITLE");
	
	NSSet *inputs = [[DataModelController theDataModelController] 
			fetchObjectsForEntityName:TAX_INPUT_ENTITY_NAME];
	if([inputs count] > 0)
	{
		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_ASSET_TAXABLE_GAIN_SECTION_TITLE")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxSourceInfo = [ItemizedTaxAmtsInfo taxSourceInfo:tax];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxSourceInfo 
				andTaxAmt:[taxSourceInfo.fieldPopulator findItemizedAssetGain:self.asset] 
				andTaxAmtCreator:[[[ItemizedAssetGainTaxAmtCreator alloc] 
					initWithAsset:self.asset andLabel:tax.name] autorelease]];				
		}
	}

	return formPopulator.formInfo;
	
}


-(void)dealloc
{
	[super dealloc];
	[asset release];
}


@end
