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
#import "DateHelper.h"
#import "SimInputHelper.h"
#import "MultiScenarioSimDate.h"

NSString * const ASSET_INPUT_ENTITY_NAME = @"AssetInput";
NSString * const INPUT_ASSET_STARTING_VALUE_KEY = @"startingValue";
NSString * const ASSET_INPUT_DEFAULT_ICON_NAME = @"input-icon-moneybag.png";

@implementation AssetInput

@dynamic assetEnabled;

@dynamic cost;
@dynamic apprecRate;
@dynamic apprecRateBeforePurchase;
@dynamic startingValue;
@dynamic purchaseDate;
@dynamic saleDate;
@dynamic assetGainItemizedTaxAmts;
@dynamic assetLossItemizedTaxAmts;



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

-(BOOL)purchaseDateDefinedAndInThePastForScenario:(Scenario*)currentScenario
{
    if([self.purchaseDate.simDate
        findInputValueForScenarioOrDefault:currentScenario] != nil)
    {
        NSDate *currentScenarioPurchaseDate =
            [SimInputHelper multiScenFixedDate:self.purchaseDate.simDate
                        andScenario:currentScenario];
        if([DateHelper dateIsLater:[DateHelper today] otherDate:currentScenarioPurchaseDate])
        {
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }
    else
    {
        return FALSE;
    }
    
}

@end
