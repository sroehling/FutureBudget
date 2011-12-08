//
//  YearValXYPlotData.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YearValXYPlotData.h"


@implementation YearValXYPlotData

@synthesize plotData;
@synthesize minYVal;
@synthesize maxYVal;

-(id)init
{
	self = [super init];
	if(self)
	{
		self.plotData = [[[NSMutableArray alloc] init] autorelease];
		self.maxYVal = -100000000000.0;
		self.minYVal = 100000000000.0;

	}
	return self;
}

-(void)addPlotDataPointForYear:(NSInteger)year andYVal:(double)yVal
{
	assert(year >= 1900);

	self.minYVal = MIN(self.minYVal,yVal);
	self.maxYVal = MAX(self.maxYVal,yVal);

	NSNumber *x = [NSNumber numberWithInteger:year];
	NSNumber *y = [NSNumber numberWithDouble:yVal];
	
	[self.plotData addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
}

-(void)dealloc
{
	[super dealloc];
	[plotData release];
}

@end
