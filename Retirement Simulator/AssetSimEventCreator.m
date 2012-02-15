//
//  AssetSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetSimEventCreator.h"

#import "InterestBearingWorkingBalance.h"
#import "AssetInput.h"

@implementation AssetSimEventCreator

@synthesize assetSimInfo;

-(id)initWithAssetSimInfo:(AssetSimInfo*)theAssetSimInfo
{
	self = [super init];
	if(self)
	{
		assert(theAssetSimInfo != nil);
		self.assetSimInfo = theAssetSimInfo;
	}
	return self;
}


- (id)init
{
	assert(0); // must call init with asset and assetValue
	return nil;
}

-(void)dealloc
{
	[assetSimInfo release];
	[super dealloc];
}


- (void)resetSimEventCreation
{
	assert(0); // must be overriden
}

- (SimEvent*)nextSimEvent
{
	assert(0); // must be overriden
	return nil;
}



@end
