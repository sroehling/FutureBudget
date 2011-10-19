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

@implementation AssetInput

@dynamic assetEnabled;

@dynamic cost;
@dynamic apprecRate;
@dynamic startingValue;
@dynamic purchaseDate;
@dynamic saleDate;


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
