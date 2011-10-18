//
//  AssetInput.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetInput.h"
#import "MultiScenarioInputValue.h"
#import "VariableValue.h"
#import "LocalizationHelper.h"
#import "InputVisitor.h"

NSString * const ASSET_INPUT_ENTITY_NAME = @"AssetInput";
NSString * const INPUT_ASSET_STARTING_VALUE_KEY = @"startingValue";
NSString * const ASSET_MULTI_SCEN_SALE_DATE_KEY = @"multiScenarioSaleDate";
NSString * const ASSET_INPUT_MULTI_SCEN_PURCHASE_DATE_KEY = @"multiScenarioPurchaseDate";

@implementation AssetInput

@dynamic multiScenarioAssetEnabled;

@dynamic cost;
@dynamic apprecRate;
@dynamic startingValue;

@dynamic multiScenarioPurchaseDate;
@dynamic multiScenarioPurchaseDateFixed;

@dynamic multiScenarioSaleDate;
@dynamic multiScenarioSaleDateFixed;
@dynamic multiScenarioSaleDateRelativeFixed;


@dynamic multiScenarioSaleProceedsTaxable;

-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
    [inputVisitor visitAsset:self];
}


-(NSString*)inlineInputType
{
	return LOCALIZED_STR(@"INPUT_ASSET_INLINE_INPUT_TYPE");
}

-(NSString*)inputTypeTitle
{
	return LOCALIZED_STR(@"INPUT_ASSET_TITLE");
}



@end
