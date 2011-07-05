//
//  MultiScenarioValueFieldInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioInputValueFieldInfo.h"
#import "MultiScenarioInputValue.h"
#import "DataModelController.h"


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



- (MultiScenarioInputValue*)inputValue
{
	MultiScenarioInputValue *inputValue;
	if(![super fieldIsInitializedInParentObject])
	{
		inputValue = (MultiScenarioInputValue*)[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
		[super setFieldValue:inputValue];
	}
	else
	{
		inputValue = (MultiScenarioInputValue*)[super getFieldValue];
		
	}
	return inputValue;
}

- (id)getFieldValue
{
	MultiScenarioInputValue *theMultiScenInputValue = [self inputValue];
	InputValue *inputVal = [theMultiScenInputValue findInputValueForScenarioOrDefault:self.currentScenario];
	assert(inputVal != nil);
	return inputVal;

}

- (void)setFieldValue:(id)newValue
{
	[self.inputValue
		setValueForScenario:self.currentScenario andInputValue:newValue];
}

- (BOOL)fieldIsInitializedInParentObject
{
	if(![super fieldIsInitializedInParentObject])
	{
		return FALSE;
	}
	else
	{
		MultiScenarioInputValue *theMultiScenInputValue = [self inputValue];
		InputValue *inputVal = [theMultiScenInputValue findInputValueForScenarioOrDefault:self.currentScenario];
		if(inputVal != nil)
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}
}


@end
