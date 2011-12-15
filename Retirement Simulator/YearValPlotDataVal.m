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
@synthesize val;

-(id)initWithYear:(NSInteger)theYear andVal:(double)theVal
{
	self = [super init];
	if(self)
	{
		assert(theYear >= 1900);
		self.year = [NSNumber numberWithInteger:theYear];
		self.val = [NSNumber numberWithDouble:theVal];
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
	[val release];
}

@end
