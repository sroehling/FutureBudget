//
//  YearValXYPlotData.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YearValXYPlotData.h"
#import "YearValPlotDataVal.h"

@implementation YearValXYPlotData

@synthesize plotData;

-(id)init
{
	self = [super init];
	if(self)
	{
		self.plotData = [[[NSMutableArray alloc] init] autorelease];
	}
	return self;
}

-(void)addPlotDataPointForYear:(NSInteger)year andYVal:(double)yVal 
		andSimStartValueMultiplier:(double)simStartAdjustmentMultiplier
{
	assert(year >= 1900);

	[self.plotData addObject:[[[YearValPlotDataVal alloc] initWithYear:year andVal:yVal andSimStartValueAdjustmentMultiplier:simStartAdjustmentMultiplier]autorelease]];
}


-(double)maxYVal:(BOOL)adjustToStartDate
{
	double theMaxYVal = -100000000000.0;
	for(YearValPlotDataVal *yearVal in self.plotData)
	{		
		double yVal;
		if(adjustToStartDate)
		{
			yVal = [yearVal.inflationAdjustedVal doubleValue];
		}
		else 
		{
			yVal = [yearVal.unadjustedVal doubleValue];
		}
		theMaxYVal = MAX(theMaxYVal,yVal);
	}
	return theMaxYVal;
}

-(double)minYVal:(BOOL)adjustToStartDate
{
	double theMinYVal = 100000000000.0;
	for(YearValPlotDataVal *yearVal in self.plotData)
	{		
		double yVal;
		if(adjustToStartDate)
		{
			yVal = [yearVal.inflationAdjustedVal doubleValue];
		}
		else 
		{
			yVal = [yearVal.unadjustedVal doubleValue];
		}
		theMinYVal = MAX(theMinYVal,yVal);
	}
	return theMinYVal;
}



-(double)getUnadjustedYValforYear:(NSInteger)year
{
	for(YearValPlotDataVal *yearVal in self.plotData)
	{
		
		NSInteger currYear = [yearVal.year integerValue];
		if(currYear == year)
		{
			double yVal = [yearVal.unadjustedVal doubleValue];
			return yVal;
		}
	}
	assert(0); // should not get here
}

-(double)getAdjustedYValforYear:(NSInteger)year
{
	for(YearValPlotDataVal *yearVal in self.plotData)
	{
		
		NSInteger currYear = [yearVal.year integerValue];
		if(currYear == year)
		{
			double yVal = [yearVal.inflationAdjustedVal doubleValue];
			return yVal;
		}
	}
	assert(0); // should not get here
}

-(void)dealloc
{
	[plotData release];
	[super dealloc];
}

@end
