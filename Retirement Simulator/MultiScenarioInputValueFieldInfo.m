//
//  MultiScenarioValueFieldInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioInputValueFieldInfo.h"


@implementation MultiScenarioInputValueFieldInfo

@synthesize currentScenario;


-(id)initWithScenario:(Scenario*)theScenario
	 andManagedObject:(NSManagedObject*)theManagedObject
		  andFieldKey:(NSString*)theFieldKey
		andFieldLabel:(NSString*)theFieldLabel
  andFieldPlaceholder:(NSString*)thePlaceholder
{
	self = [super initWithManagedObject:theManagedObject andFieldKey:theFieldKey andFieldLabel:theFieldLabel andFieldPlaceholder:thePlaceholder];
	if(self)
	{
		assert(theScenario != nil);
		self.currentScenario = theScenario;
	}
	return self;
}

- (id)getFieldValue
{
	return [super getFieldValue];
}


- (void)setFieldValue:(id)newValue
{
	[super setFieldValue:newValue];
}

- (BOOL)fieldIsInitializedInParentObject
{
	if(![super fieldIsInitializedInParentObject])
	{
		return FALSE;
	}
	else
	{
		return FALSE;
	}
}


@end
