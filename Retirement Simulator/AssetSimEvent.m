//
//  AssetSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetSimEvent.h"
#import "InterestBearingWorkingBalance.h"

@implementation AssetSimEvent

@synthesize assetSimInfo;

-(id)initWithAssetSimInfo:(AssetSimInfo*)theAssetSimInfo 
	andSimEventCreator:(id<SimEventCreator>)eventCreator andEventDate:(NSDate*)eventDate
{
	self = [super initWithEventCreator:eventCreator andEventDate:eventDate];
	if(self)
	{
		assert(theAssetSimInfo != nil);
		self.assetSimInfo = theAssetSimInfo;
	}
	return self;
}


-(id)init
{
	assert(0); // must init with asset value
	return nil;
}

-(void)dealloc
{
	[super dealloc];
	[assetSimInfo release];
}

@end
