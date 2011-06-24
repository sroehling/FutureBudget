//
//  FixedValueAsOfCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FixedValueAsOfCalculator.h"

#import "FixedValue.h"

@implementation FixedValueAsOfCalculator

@synthesize fixedVal;

-(id) initWithFixedValue:(FixedValue*)theFixedValue
{
	self = [super init];
	if(self)
	{
		self.fixedVal = theFixedValue;
	}
	return self;
}

- (id) init 
{
	assert(0);
	return nil;
}

- (double)valueAsOfDate:(NSDate*)theDate
{
	return [self.fixedVal.value doubleValue];
}

- (void) dealloc
{
	[super dealloc];
	[fixedVal release];
}

@end
