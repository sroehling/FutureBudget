//
//  MultiScenarioFixedDateFieldInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioFixedDateFieldInfo.h"

#import "Scenario.h"
#import "MultiScenarioInputValue.h"
#import "FixedDate.h"
#import "DataModelController.h"


@implementation MultiScenarioFixedDateFieldInfo

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
	FixedDate *theDateVal = (FixedDate*)[self.inputVal findInputValueForScenarioOrDefault:self.currentScen];
	assert(theDateVal != nil); // value must be set for current scenario or default
	return theDateVal.date;
}

- (NSManagedObject*)managedObject
{
	FixedDate *theDateVal = (FixedDate*)[self.inputVal findInputValueForScenarioOrDefault:self.currentScen];
	assert(theDateVal != nil); // value must be set for current scenario or default
	return theDateVal;
}


- (void)setFieldValue:(NSObject*)newValue
{
	
	assert([newValue isKindOfClass:[NSDate class]]);
	FixedDate *dateVal = (FixedDate*)[self.inputVal findInputValueForScenario:self.currentScen];
	if(dateVal != nil)
	{
		dateVal.date = (NSDate*)newValue;
	}
	else
	{
		FixedDate *newDateVal = (FixedDate*)[[DataModelController theDataModelController] 
			insertObject:FIXED_DATE_ENTITY_NAME];
		newDateVal.date = (NSDate*)newValue;
		[self.inputVal setValueForScenario:self.currentScen andInputValue:newDateVal];
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
