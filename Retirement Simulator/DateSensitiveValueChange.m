//
//  DateSensitiveValueChange.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueChange.h"
#import "SimDate.h"

NSString * const DATE_SENSITIVE_VALUE_CHANGE_START_DATE_SORT_KEY = @"resolvedStartDate";
NSString * const DATE_SENSITIVE_VALUE_CHANGE_ENTITY_NAME = @"DateSensitiveValueChange";
NSString * const DATE_SENSITIVE_VALUE_CHANGE_START_DATE_KEY = @"startDate";
NSString * const DATE_SENSITIVE_VALUE_CHANGE_NEW_VALUE_KEY = @"valueAfterChange";

@implementation DateSensitiveValueChange
@dynamic startDate;
@dynamic defaultFixedStartDate;
@dynamic valueAfterChange;

// Inverse property
@dynamic variableValueValueChange;



-(NSDate*)resolvedStartDate
{
	assert(self.startDate != nil);
	return self.startDate.date;
}


@end


