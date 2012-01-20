//
//  AssetGainItemizedTaxAmt.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetGainItemizedTaxAmt.h"
#import "ItemizedTaxAmtVisitor.h"
#import "SimInputHelper.h"
#import "AssetInput.h"

NSString * const ASSET_GAIN_ITEMIZED_TAX_AMT_ENTITY_NAME = 
	@"AssetGainItemizedTaxAmt";

@implementation AssetGainItemizedTaxAmt

@dynamic asset;

-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor
{
	assert(visitor != nil);
	[visitor visitAssetGainItemizedTaxAmt:self];
}

-(BOOL)itemIsEnabledForScenario:(Scenario*)theScenario
{
	assert(theScenario != nil);
	assert(self.asset != nil);
	if([self.isEnabled boolValue])
	{
		return [SimInputHelper multiScenBoolVal:self.asset.assetEnabled
				andScenario:theScenario];
	}
	else
	{
		return FALSE;
	}
}

@end
