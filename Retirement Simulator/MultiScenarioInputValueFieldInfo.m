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
#import "InputValue.h"


@implementation MultiScenarioInputValueFieldInfo

@synthesize currentScenario;
@synthesize multiScenInputVal;



-(id)initWithScenario:(Scenario*)theScenario 
	andMultiScenarioInputVal:(MultiScenarioInputValue*)theMultiScenInputVal
	andFieldLabel:(NSString*)theFieldLabel
			andFieldPlaceholder:(NSString*)thePlaceholder
{
	self = [super initWithFieldLabel:theFieldLabel andFieldPlaceholder:thePlaceholder];
	if(self)
	{
		assert(theScenario != nil);
		self.currentScenario = theScenario;
		
		assert(theMultiScenInputVal != nil);
		self.multiScenInputVal = theMultiScenInputVal;
		
	}
	return self;	
}



- (id)getFieldValue
{
	InputValue *inputVal = [self.multiScenInputVal findInputValueForScenarioOrDefault:self.currentScenario];
	assert(inputVal != nil);
	return inputVal;

}

- (void)setFieldValue:(NSObject*)newValue
{
	assert([newValue isKindOfClass:[InputValue class]]);
	[self.multiScenInputVal
		setValueForScenario:self.currentScenario andInputValue:(InputValue*)newValue];
}

- (BOOL)fieldIsInitializedInParentObject
{

	InputValue *inputVal = [self.multiScenInputVal findInputValueForScenarioOrDefault:self.currentScenario];
	if(inputVal != nil)
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

-(NSManagedObject*)managedObject
{
	return [self getFieldValue];
}

- (void)dealloc
{
	[super dealloc];
	[currentScenario release];
	[multiScenInputVal release];
}

@end
