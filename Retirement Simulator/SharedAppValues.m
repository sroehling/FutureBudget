//
//  SharedAppValues.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SharedAppValues.h"
#import "NeverEndDate.h"
#import "DataModelController.h"
#import "EventRepeatFrequency.h"
#import "DefaultScenario.h"


NSString * const SHARED_APP_VALUES_ENTITY_NAME = @"SharedAppValues";
NSString * const SHARED_APP_VALUES_CURRENT_INPUT_SCENARIO_KEY = @"currentInputScenario";

@implementation SharedAppValues

@dynamic sharedNeverEndDate;
@dynamic defaultScenario;
@dynamic currentInputScenario;
@dynamic repeatOnceFreq;
@dynamic simStartDate;

static SharedAppValues *theSharedAppVals;  


+(SharedAppValues*)singleton
{  
	assert(theSharedAppVals != nil);
	return theSharedAppVals;
}

+(void)initSingleton:(SharedAppValues*)theAppVals
{
	assert(theSharedAppVals == nil);
	assert(theAppVals != nil);
	[theAppVals retain];
	theSharedAppVals = theAppVals;
}

+(void)initFromDatabase
{
    NSLog(@"Initializing database with default data ...");
    
    
    if(![[DataModelController theDataModelController] entitiesExistForEntityName:SHARED_APP_VALUES_ENTITY_NAME])
	{
		NSLog(@"Initializing shared values ...");

        EventRepeatFrequency *repeatOnce = 
			[EventRepeatFrequency createWithPeriod:kEventPeriodOnce andMultiplier:1];
        [EventRepeatFrequency createWithPeriod:kEventPeriodWeek andMultiplier:1];
        [EventRepeatFrequency createWithPeriod:kEventPeriodWeek andMultiplier:2];
        [EventRepeatFrequency createWithPeriod:kEventPeriodMonth andMultiplier:1];
        [EventRepeatFrequency createWithPeriod:kEventPeriodMonth andMultiplier:3];
        [EventRepeatFrequency createWithPeriod:kEventPeriodMonth andMultiplier:6];
        [EventRepeatFrequency createWithPeriod:kEventPeriodYear andMultiplier:1];        


		SharedAppValues *sharedVals = [[DataModelController theDataModelController] insertObject:SHARED_APP_VALUES_ENTITY_NAME];
		NeverEndDate *theNeverEndDate = [[DataModelController theDataModelController] insertObject:NEVER_END_DATE_ENTITY_NAME];
		theNeverEndDate.date = [[[NSDate alloc] init] autorelease];
		sharedVals.sharedNeverEndDate = theNeverEndDate;
		
		DefaultScenario *defaultScenario = (DefaultScenario*)[[DataModelController theDataModelController] insertObject:DEFAULT_SCENARIO_ENTITY_NAME];
		sharedVals.defaultScenario = defaultScenario;
		sharedVals.currentInputScenario = defaultScenario;
		
		sharedVals.repeatOnceFreq = repeatOnce;
		
		sharedVals.simStartDate = [[[NSDate alloc] init] autorelease];
		
		[SharedAppValues initSingleton:sharedVals];

	}
	else
	{
		NSSet *theAppVals = [[DataModelController theDataModelController] fetchObjectsForEntityName:SHARED_APP_VALUES_ENTITY_NAME];
		assert([theAppVals count] == 1);
		[SharedAppValues initSingleton:(SharedAppValues*)[theAppVals anyObject]];
	}
        
    [[DataModelController theDataModelController] saveContext];


}



@end
