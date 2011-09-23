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
NSString * const INPUT_ASSET_MULTI_SCEN_COST_KEY = @"multiScenarioCost";
NSString * const INPUT_ASSET_STARTING_VALUE_KEY = @"startingValue";
NSString * const INPUT_ASSET_MULTI_SCEN_APPREC_RATE_KEY = @"multiScenarioApprecRate";
NSString * const ASSET_MULTI_SCEN_SALE_DATE_KEY = @"multiScenarioSaleDate";
NSString * const ASSET_INPUT_MULTI_SCEN_PURCHASE_DATE_KEY = @"multiScenarioPurchaseDate";

@implementation AssetInput

@dynamic multiScenarioAssetEnabled;

@dynamic multiScenarioCost;
@dynamic multiScenarioCostFixed;
@dynamic multiScenarioApprecRate;
@dynamic multiScenarioApprecRateFixed;
@dynamic startingValue;

@dynamic multiScenarioPurchaseDate;
@dynamic multiScenarioPurchaseDateFixed;
@dynamic multiScenarioSaleDate;
@dynamic multiScenarioSaleDateFixed;
@dynamic multiScenarioSaleDateRelativeFixed;


@dynamic multiScenarioSaleProceedsTaxable;


@dynamic variableAssetValues;

- (void)addVariableAssetValuesObject:(VariableValue *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"variableAssetValues" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"variableAssetValues"] addObject:value];
    [self didChangeValueForKey:@"variableAssetValues" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeVariableAssetValuesObject:(VariableValue *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"variableAssetValues" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"variableAssetValues"] removeObject:value];
    [self didChangeValueForKey:@"variableAssetValues" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addVariableAssetValues:(NSSet *)value {    
    [self willChangeValueForKey:@"variableAssetValues" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"variableAssetValues"] unionSet:value];
    [self didChangeValueForKey:@"variableAssetValues" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeVariableAssetValues:(NSSet *)value {
    [self willChangeValueForKey:@"variableAssetValues" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"variableAssetValues"] minusSet:value];
    [self didChangeValueForKey:@"variableAssetValues" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

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
