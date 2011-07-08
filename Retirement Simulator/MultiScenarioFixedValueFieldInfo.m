//
//  MultiScenarioFixedValueFieldInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioFixedValueFieldInfo.h"
#import "Scenario.h"
#import "MultiScenarioInputValue.h"
#import "FixedValue.h"
#import "DataModelController.h"


@implementation MultiScenarioFixedValueFieldInfo


@synthesize inputVal;
@synthesize currentScen;

-(id)initWithFieldLabel:(NSString *)theFieldLabel andFieldPlaceholder:(NSString *)thePlaceholder
	andScenario:(Scenario*)currScenario andInputVal:(MultiScenarioInputValue*)theInputVal
{
	self = [super initWithFieldLabel:theFieldLabel andFieldPlaceholder:thePlaceholder];
	if(self)
	{
		assert(currScenario != nil);
		assert(theInputVal != nil);
		self.currentScen = currScenario;
		self.inputVal = theInputVal;
	}
	return self;
}

- (id) initWithFieldLabel:(NSString *)theFieldLabel andFieldPlaceholder:(NSString *)thePlaceholder
{
	assert(0);
	return nil;
}

- (id) init
{
	assert(0);
	return nil;
}

- (id)getFieldValue
{
	FixedValue *theVal = (FixedValue*)[self.inputVal findInputValueForScenarioOrDefault:self.currentScen];
	assert(theVal != nil); // value must be set for current scenario or default
	return theVal.value;
}

- (NSManagedObject*)managedObject
{
	FixedValue *theVal = (FixedValue*)[self.inputVal findInputValueForScenarioOrDefault:self.currentScen];
	assert(theVal != nil); // value must be set for current scenario or default
	return theVal;
}


- (void)setFieldValue:(NSObject*)newValue
{
	
	assert([newValue isKindOfClass:[NSNumber class]]);
	FixedValue *theVal = (FixedValue*)[self.inputVal findInputValueForScenario:self.currentScen];
	if(theVal != nil)
	{
		theVal.value = (NSNumber*)newValue;
	}
	else
	{
		FixedValue *newVal = (FixedValue*)[[DataModelController theDataModelController] 
			insertObject:FIXED_VALUE_ENTITY_NAME];
		newVal.value = (NSNumber*)newValue;
		[self.inputVal setValueForScenario:self.currentScen andInputValue:newVal];
	}
}


- (BOOL)fieldIsInitializedInParentObject
{
	return TRUE;
}

-(void)dealloc
{
	[super dealloc];
	[inputVal release];
	[currentScen release];
}


@end
