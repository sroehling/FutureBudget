//
//  AssetLossItemizedTaxAmt.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/17/13.
//
//

#import "AssetLossItemizedTaxAmt.h"
#import "ItemizedTaxAmtVisitor.h"
#import "SimInputHelper.h"
#import "AssetInput.h"

NSString * const ASSET_LOSS_ITEMIZED_TAX_AMT_ENTITY_NAME =
	@"AssetLossItemizedTaxAmt";


@implementation AssetLossItemizedTaxAmt

@dynamic asset;

-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor
{
	assert(visitor != nil);
	[visitor visitAssetLossItemizedTaxAmt:self];
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
