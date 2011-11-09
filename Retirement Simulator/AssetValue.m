//
//  AssetValue.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetValue.h"
#import "AssetGainItemizedTaxAmt.h"

NSString * const ASSET_VALUE_ENTITY_NAME = @"AssetValue";

@implementation AssetValue

@dynamic assetGainItemizedTaxAmts;

- (void)addAssetGainItemizedTaxAmtsObject:(AssetGainItemizedTaxAmt *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"assetGainItemizedTaxAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"assetGainItemizedTaxAmts"] addObject:value];
    [self didChangeValueForKey:@"assetGainItemizedTaxAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAssetGainItemizedTaxAmtsObject:(AssetGainItemizedTaxAmt *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"assetGainItemizedTaxAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"assetGainItemizedTaxAmts"] removeObject:value];
    [self didChangeValueForKey:@"assetGainItemizedTaxAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAssetGainItemizedTaxAmts:(NSSet *)value {    
    [self willChangeValueForKey:@"assetGainItemizedTaxAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"assetGainItemizedTaxAmts"] unionSet:value];
    [self didChangeValueForKey:@"assetGainItemizedTaxAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAssetGainItemizedTaxAmts:(NSSet *)value {
    [self willChangeValueForKey:@"assetGainItemizedTaxAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"assetGainItemizedTaxAmts"] minusSet:value];
    [self didChangeValueForKey:@"assetGainItemizedTaxAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



@end
