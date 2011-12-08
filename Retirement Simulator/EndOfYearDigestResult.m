//
//  EndOfYearDigestResult.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EndOfYearDigestResult.h"
#import "NumberHelper.h"
#import "DateHelper.h"
#import "EndOfYearInputResults.h"

@implementation EndOfYearDigestResult

@synthesize endDate;
@synthesize totalEndOfYearBalance;
@synthesize assetValues;
@synthesize sumAssetVals;

-(id)initWithEndDate:(NSDate *)endOfYearDate
{
	self = [super init];
	if(self)
	{
		assert(endOfYearDate != nil);
		self.endDate = endOfYearDate;
		self.totalEndOfYearBalance = 0.0;
		
		self.assetValues = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumAssetVals = 0.0;
	}
	return self;

}

-(id) init
{
	assert(0); // must call with end date
}


- (NSInteger)yearNumber
{
	return [DateHelper yearOfDate:self.endDate];
}

- (void)logResults
{

}

- (void) dealloc
{
	[super dealloc];
	[assetValues release];
}

@end
