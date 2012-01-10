//
//  YearValPlotDataVal.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YearValPlotDataVal.h"


@implementation YearValPlotDataVal

@synthesize year;
@synthesize unadjustedVal;
@synthesize inflationAdjustedVal;
@synthesize simStartValueAdjustmentMultiplier;

-(id)initWithYear:(NSInteger)theYear andVal:(double)theVal
	andSimStartValueAdjustmentMultiplier:(double)theSimStartValMult
{
	self = [super init];
	if(self)
	{
		assert(theYear >= 1900);
		self.year = [NSNumber numberWithInteger:theYear];
		self.unadjustedVal = [NSNumber numberWithDouble:theVal];
		
		assert(theSimStartValMult > 0.0);
		self.simStartValueAdjustmentMultiplier = theSimStartValMult;
		
		self.inflationAdjustedVal = [NSNumber numberWithDouble:(theVal * theSimStartValMult)];
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(void)dealloc
{
	[super dealloc];
	[year release];
	[unadjustedVal release];
	[inflationAdjustedVal release];
}

@end
