//
//  FixedDate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FixedDate.h"
#import "SimDateVisitor.h"

NSString * const FIXED_DATE_ENTITY_NAME = @"FixedDate";

@implementation FixedDate

// Inverse relationship

// TODO - Need more handling for cascading deletes involving
// this object. As it is implemented now, deleting a reference to this
// fixed value will result in an orphan.
@dynamic dateSensValChangeDefaultStartDate;
@dynamic sharedAppValsDefaultFixedSimEndDate;


- (NSString *)inlineDescription:(NSDateFormatter*)withFormat
{
	return [withFormat stringFromDate:self.date];
}

- (void)acceptVisitor:(id<SimDateVisitor>)visitor
{
	[visitor visitFixedDate:self];
}

@end

