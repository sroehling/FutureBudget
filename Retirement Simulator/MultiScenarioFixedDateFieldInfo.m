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
@synthesize dataModelController;

-(id)initWithDataModelController:(DataModelController*)theDataModelController 
	andFieldLabel:(NSString *)theFieldLabel andFieldPlaceholder:(NSString *)thePlaceholder
	andScenario:(Scenario*)currScenario andInputVal:(MultiScenarioInputValue*)theInputVal
{
	self = [super initWithFieldLabel:theFieldLabel andFieldPlaceholder:thePlaceholder];
	if(self)
	{
		assert(currScenario != nil);
		assert(theInputVal != nil);
		assert(theDataModelController != nil);
		self.currentScen = currScenario;
		self.inputVal = theInputVal;
		self.dataModelController = theDataModelController;
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
		FixedDate *newDateVal = (FixedDate*)[self.dataModelController 
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
	[inputVal release];
	[dataModelController release];
	[currentScen release];
	[super dealloc];
}

@end
