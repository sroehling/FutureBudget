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
#import "InputCreationHelper.h"

@implementation ItemizedAssetGainTaxAmtCreator

@synthesize asset;

-(id)initWithAsset:(AssetInput*)theAsset
{
	self = [super init];
	if(self)
	{
		assert(theAsset != nil);
		self.asset = theAsset;
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
	return self.asset.name;
}

-(void)dealloc
{
	[super dealloc];
	[asset release];
}

@end
