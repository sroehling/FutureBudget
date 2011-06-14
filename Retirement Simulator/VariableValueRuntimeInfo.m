//
//  VariableValueRuntimeInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableValueRuntimeInfo.h"


@implementation VariableValueRuntimeInfo

@synthesize valueFormatter;
@synthesize entityName;
@synthesize valueTitle;
@synthesize valueVerb;

- (id) initWithEntityName:(NSString*)entity andFormatter:(NSNumberFormatter*)valFormatter
	andValueTitle:(NSString *)title andValueVerb:(NSString*)verb
{
	self = [super init];
	if(self)
	{
		assert(valFormatter != nil);
		assert(entity != nil);
		assert([entity length] >0);
		assert(title != nil);
		assert([title length] > 0);
		self.valueFormatter = valFormatter;
		self.entityName = entity;
		self.valueTitle = title;
		self.valueVerb = verb;
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
	[valueFormatter release];
	[entityName release];
	[valueTitle release];
	[valueVerb release];
}

@end
