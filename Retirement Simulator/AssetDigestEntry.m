//
//  AssetPurchaseDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetDigestEntry.h"
#import "AssetSimInfo.h"

@implementation AssetDigestEntry

@synthesize assetInfo;

-(id)initWithAssetSimInfo:(AssetSimInfo*)theAssetInfo
{
	self = [super init];
	if(self)
	{
		assert(theAssetInfo != nil);
		self.assetInfo = theAssetInfo;
	}
	return self;
}

- (id)init
{
	assert(0); // must init with asset sim info
	return nil;
}

- (void) dealloc
{
	[super dealloc];
	[assetInfo release];
}


@end
