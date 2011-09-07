//
//  BoolInputValueFieldInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioBoolInputValueFieldInfo.h"
#import "BoolInputValue.h"
#import "MultiScenarioInputValue.h"
#import "DataModelController.h"


@implementation MultiScenarioBoolInputValueFieldInfo

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
	BoolInputValue *theVal = (BoolInputValue*)[self.inputVal findInputValueForScenarioOrDefault:self.currentScen];
	assert(theVal != nil); // value must be set for current scenario or default
	return theVal.isTrue;
}

- (NSManagedObject*)managedObject
{
	BoolInputValue *theVal = (BoolInputValue*)[self.inputVal findInputValueForScenarioOrDefault:self.currentScen];
	assert(theVal != nil); // value must be set for current scenario or default
	return theVal;
}


- (void)setFieldValue:(NSObject*)newValue
{
	
	assert([newValue isKindOfClass:[NSNumber class]]);
	BoolInputValue *theVal = (BoolInputValue*)[self.inputVal 
		findInputValueForScenario:self.currentScen];
	if(theVal != nil)
	{
		theVal.isTrue = (NSNumber*)newValue;
	}
	else
	{
		BoolInputValue *newVal = (BoolInputValue*)[[DataModelController theDataModelController] 
			insertObject:BOOL_INPUT_VALUE_ENTITY_NAME];
		newVal.isTrue = (NSNumber*)newValue;
		[self.inputVal setValueForScenario:self.currentScen andInputValue:newVal];
	}
}

- (BOOL)fieldIsInitializedInParentObject
{
	return TRUE;
}

- (void)dealloc
{
	[super dealloc];
	[inputVal release];
	[currentScen release];
}

@end
