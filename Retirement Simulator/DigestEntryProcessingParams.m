//
//  DigestEntryProcessingParams.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DigestEntryProcessingParams.h"
#import "DateHelper.h"


@implementation DigestEntryProcessingParams

@synthesize workingBalanceMgr;
@synthesize dayIndex;
@synthesize currentDate;

-(id)initWithWorkingBalanceMgr:(WorkingBalanceMgr*)theWorkingBalanceMgr
	andDayIndex:(NSInteger)theDayIndex andCurrentDate:(NSDate*)theCurrentDate;
{
	self = [super init];
	if(self)
	{
		assert(theWorkingBalanceMgr != nil);
		self.workingBalanceMgr = theWorkingBalanceMgr;
		
		assert(theDayIndex >= 0);
		assert(theDayIndex <= MAX_DAYS_IN_YEAR);
		self.dayIndex = theDayIndex;
		
		assert(theCurrentDate != nil);
		self.currentDate = theCurrentDate;
	}
	return self;
}

-(id)init
{
	assert(0); // must call init method above
	return nil;
}

-(void)dealloc
{
	[super dealloc];
	[workingBalanceMgr release];
	[currentDate release];
}

@end
