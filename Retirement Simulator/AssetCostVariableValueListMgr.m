//
//  AssetCostVariableValueListMgr.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetCostVariableValueListMgr.h"
#import "CollectionHelper.h"
#import "AssetInput.h"
#import "AssetValue.h"
#import "DataModelController.h"


@implementation AssetCostVariableValueListMgr

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
	// must init with asset
	assert(0);
	return nil;
}

-(void)dealloc
{
	[super dealloc];
	[asset release];
}


- (NSArray*)variableValues
{
	return [CollectionHelper setToSortedArray:self.asset.variableAssetValues withKey:@"name"];	
}

- (VariableValue*)createNewValue
{
	return (VariableValue*)[[DataModelController theDataModelController]
							insertObject:ASSET_VALUE_ENTITY_NAME];	
}

-(void)objectFinshedBeingAdded:(NSManagedObject*)addedObject
{
	[self.asset addVariableAssetValuesObject:(VariableValue*)addedObject];
}




@end
