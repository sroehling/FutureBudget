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
#import "FormContext.h"
#import "SharedAppValues.h"
#import "InputCreationHelper.h"

@implementation ItemizedAssetGainTaxAmtCreator

@synthesize asset;
@synthesize label;
@synthesize formContext;

-(id)initWithFormContext:(FormContext*)theFormContext
	andAsset:(AssetInput*)theAsset andLabel:(NSString*)theLabel
{
	self = [super init];
	if(self)
	{
		assert(theAsset != nil);
		self.asset = theAsset;
		
		assert([StringValidation nonEmptyString:theLabel]);
		self.label = theLabel;
		
		assert(theFormContext != nil);
		self.formContext = theFormContext;
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
	AssetGainItemizedTaxAmt *itemizedTaxAmt = [self.formContext.dataModelController insertObject:ASSET_GAIN_ITEMIZED_TAX_AMT_ENTITY_NAME];
	SharedAppValues *sharedAppVals = [SharedAppValues getUsingDataModelController:self.formContext.dataModelController];
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] 
		initWithDataModelController:self.formContext.dataModelController
		andSharedAppVals:sharedAppVals] autorelease];
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
	[asset release];
	[label release];
	[formContext release];
	[super dealloc];
}

@end
