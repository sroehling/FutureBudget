//
//  DateSensitiveValueChange.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueChange.h"
#import "SimDate.h"


@implementation DateSensitiveValueChange
@dynamic startDate;
@dynamic defaultFixedStartDate;
@dynamic newValue;

-(NSDate*)resolvedStartDate
{
	assert(self.startDate != nil);
	return self.startDate.date;
}


@end

NSString * const DATE_SENSITIVE_VALUE_CHANGE_START_DATE_SORT_KEY = @"resolvedStartDate";
NSString * const DATE_SENSITIVE_VALUE_CHANGE_ENTITY_NAME = @"DateSensitiveValueChange";

