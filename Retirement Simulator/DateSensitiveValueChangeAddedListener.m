//
//  DateSensitiveValueChangeAddedListener.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueChangeAddedListener.h"

#import "VariableValue.h"

@implementation DateSensitiveValueChangeAddedListener

@synthesize valueToAddTo;

- (id)initWithVariableValue:(VariableValue*)variableValue
{
	self = [super init];
	if(self)
	{
	assert(variableValue != nil);
		self.valueToAddTo = variableValue;
	}
	return self;
}

- (id) init
{
	assert(0); // must not be called
	return nil;
}

-(void)objectFinshedBeingAdded:(NSManagedObject*)addedObject
{
	assert(self.valueToAddTo != nil);
	assert(addedObject != nil);
	[self.valueToAddTo addValueChangesObject:(DateSensitiveValueChange*)addedObject];
}

- (void) dealloc
{
	[super dealloc];
	[valueToAddTo release];
}

@end
