//
//  YearlySimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YearlySimEventCreator.h"
#import "EventRepeater.h"
#import "SharedAppValues.h"
#import "DateHelper.h"
#import "NeverEndDate.h"

@implementation YearlySimEventCreator


- (id) initWithStartingMonth:(NSInteger)monthNum andStartingDay:(NSInteger)dayNum
	andSimStartDate:(NSDate*)simStart
{
	self = [super initWithStartingMonth:monthNum andStartingDay:dayNum
			andSimStartDate:simStart andPeriod:kEventPeriodYear];
	if(self)
	{
	}
	return self;
}

@end
