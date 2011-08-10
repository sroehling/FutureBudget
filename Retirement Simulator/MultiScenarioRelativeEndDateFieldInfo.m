//
//  MultiScenarioRelativeEndDateFieldInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioRelativeEndDateFieldInfo.h"
#import "MultiScenarioInputValue.h"
#import "DataModelController.h"
#import "RelativeEndDate.h"
#import "RelativeEndDateInfo.h"


@implementation MultiScenarioRelativeEndDateFieldInfo


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
	RelativeEndDate *theRelEndDate = (RelativeEndDate*)
		[self.inputVal findInputValueForScenarioOrDefault:self.currentScen];
	assert(theRelEndDate != nil); // value must be set for current scenario or default
	
	return [theRelEndDate relEndDateInfo];
}

- (NSManagedObject*)managedObject
{
	RelativeEndDate *theRelEndDate = (RelativeEndDate*)
		[self.inputVal findInputValueForScenarioOrDefault:self.currentScen];
	assert(theRelEndDate != nil); // value must be set for current scenario or default
	return theRelEndDate;
}


- (void)setFieldValue:(NSObject*)newValue
{
	
	assert([newValue isKindOfClass:[RelativeEndDateInfo class]]);
	RelativeEndDateInfo *newRelEndDateInfo = (RelativeEndDateInfo*)newValue;
	RelativeEndDate *existingRelEndDate = (RelativeEndDate*)
		[self.inputVal findInputValueForScenario:self.currentScen];
	if(existingRelEndDate != nil)
	{
		[existingRelEndDate setWithRelEndDateInfo:newRelEndDateInfo];
	}
	else
	{
		RelativeEndDate *newRelEndDate = (RelativeEndDate*)
			[[DataModelController theDataModelController] insertObject:RELATIVE_END_DATE_ENTITY_NAME];
		[newRelEndDate setWithRelEndDateInfo:newRelEndDateInfo];

		[self.inputVal setValueForScenario:self.currentScen andInputValue:newRelEndDate];
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
