//
//  VariableDate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SimDate.h"
#import "SimDateVisitor.h"

NSString * const SIM_DATE_DATE_KEY = @"date";

@implementation SimDate

@synthesize isSelectedForSelectableObjectTableView;

@dynamic date;

// TODO - Need more handling for cascading deletes involving
// this object. As it is implemented now, deleting a reference to this
// fixed value will result in an orphan.
@dynamic dateSensitiveValueChangeStartDate;
@dynamic sharedAppValsSimEndDate;

- (NSComparisonResult)compare:(SimDate *)otherObject {
	assert(self.date != nil);
	assert(otherObject.date != nil);
    return [self.date compare:otherObject.date];
}

- (NSString *)inlineDescription:(NSDateFormatter*)withFormat
{
	assert(0); // must be overridden
	return nil;
}

- (void)acceptVisitor:(id<SimDateVisitor>)visitor
{
	assert(0); // must be overridden
}

- (NSDate*)endDateWithStartDate:(NSDate*)startDate
{
	return self.date;
}



@end
