//
//  ItemizedAssetLossTaxFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/17/13.
//
//

#import "ItemizedAssetLossTaxFormInfoCreator.h"

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
#import "AssetLossItemizedTaxAmt.h"
#import "ItemizedAssetLossTaxAmtCreator.h"
#import "ItemizedTaxAmtFieldEditInfo.h"
#import "FormContext.h"
#import "StringValidation.h"


@implementation ItemizedAssetLossTaxFormInfoCreator

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
	
	NSString *formHeader = [StringValidation nonEmptyString:self.asset.name]?
		[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_ASSET_LOSS_TAX_DETAIL_HEADER_FORMAT"),
			self.asset.name]:LOCALIZED_STR(@"INPUT_ASSET_LOSS_TAX_DETAIL_HEADER_NAME_UNDEFINED");

	[formPopulator populateWithHeader:formHeader
		andSubHeader:LOCALIZED_STR(@"INPUT_ASSET_LOSS_TAX_DETAIL_SUBHEADER")];

	
	NSSet *inputs = [parentContext.dataModelController
			fetchObjectsForEntityName:TAX_INPUT_ENTITY_NAME];
	if([inputs count] > 0)
	{
		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_ASSET_DEDUCTABLE_ASSET_LOSSES_SECTION_TITLE")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxDeductionInfo = [ItemizedTaxAmtsInfo taxDeductionInfo:tax
				usingDataModelController:parentContext.dataModelController];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxDeductionInfo
				andTaxAmt:[taxDeductionInfo.fieldPopulator findItemizedAssetLoss:self.asset]
				andTaxAmtCreator:[[[ItemizedAssetLossTaxAmtCreator alloc]
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
