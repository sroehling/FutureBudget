//
//  ItemizedAssetGainTaxAmtCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedAssetGainTaxAmtCreator.h"
#import "AssetGainItemizedTaxAmt.h"
#import "AssetInput.h"
#import "DataModelController.h"
#import "StringValidation.h"
#import "InputCreationHelper.h"

@implementation ItemizedAssetGainTaxAmtCreator

@synthesize asset;
@synthesize label;

-(id)initWithAsset:(AssetInput*)theAsset andLabel:(NSString*)theLabel
{
	self = [super init];
	if(self)
	{
		assert(theAsset != nil);
		self.asset = theAsset;
		
		assert([StringValidation nonEmptyString:theLabel]);
		self.label = theLabel;
	}
	return self;
}

-(id)init
{
	assert(0); // must init with asset
	return nil;
}

- (ItemizedTaxAmt*)createItemizedTaxAmt
{
	assert(asset != nil);
	AssetGainItemizedTaxAmt *itemizedTaxAmt = [[DataModelController theDataModelController] insertObject:ASSET_GAIN_ITEMIZED_TAX_AMT_ENTITY_NAME];
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] 
		initForDatabaseInputs] autorelease];
	itemizedTaxAmt.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedTaxAmt.asset  = self.asset;
	return itemizedTaxAmt;
}


-(NSString*)itemLabel
{
	return self.label;
}

-(void)dealloc
{
	[super dealloc];
	[asset release];
	[label release];
}

@end
