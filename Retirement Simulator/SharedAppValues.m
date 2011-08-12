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
#import "FixedDate.h"
#import "DateHelper.h"
#import "EventRepeatFrequency.h"
#import "DefaultScenario.h"
#import "RelativeEndDate.h"


NSString * const SHARED_APP_VALUES_ENTITY_NAME = @"SharedAppValues";
NSString * const SHARED_APP_VALUES_CURRENT_INPUT_SCENARIO_KEY = @"currentInputScenario";
NSString * const SHARED_APP_VALUES_SIM_START_DATE_KEY = @"simStartDate";
NSString * const SHARED_APP_VALUES_SIM_END_DATE_KEY = @"simEndDate";
NSString * const SHARED_APP_VALUES_DEFAULT_FIXED_SIM_END_DATE_KEY = @"defaultFixedSimEndDate";
NSString * const SHARED_APP_VALUES_DEFAULT_RELATIVE_SIM_END_DATE_KEY = @"defaultFixedRelativeEndDate";

#define DEFAULT_SIM_END_DATE_OFFSET_YEARS 50

@implementation SharedAppValues

@dynamic sharedNeverEndDate;
@dynamic defaultScenario;
@dynamic currentInputScenario;
@dynamic repeatOnceFreq;
@dynamic simStartDate;
@dynamic simEndDate;
@dynamic defaultFixedSimEndDate;
@dynamic defaultFixedRelativeEndDate;

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
		theNeverEndDate.date = [DateHelper dateFromStr:NEVER_END_PSEUDO_END_DATE];
		sharedVals.sharedNeverEndDate = theNeverEndDate;
		
		DefaultScenario *defaultScenario = (DefaultScenario*)[[DataModelController theDataModelController] insertObject:DEFAULT_SCENARIO_ENTITY_NAME];
		sharedVals.defaultScenario = defaultScenario;
		sharedVals.currentInputScenario = defaultScenario;
		
		sharedVals.repeatOnceFreq = repeatOnce;
		
		sharedVals.simStartDate = [[[NSDate alloc] init] autorelease];
		
		RelativeEndDate *theSimEndDate = [[DataModelController theDataModelController] insertObject:RELATIVE_END_DATE_ENTITY_NAME];
		theSimEndDate.years = [NSNumber numberWithInt:DEFAULT_SIM_END_DATE_OFFSET_YEARS];
		theSimEndDate.months = [NSNumber numberWithInt:0];
		theSimEndDate.weeks = [NSNumber numberWithInt:0];
		sharedVals.simEndDate = theSimEndDate;
		sharedVals.defaultFixedRelativeEndDate = theSimEndDate;

		
		FixedDate *fixedEndDate = (FixedDate*)[[
			DataModelController theDataModelController] insertObject:FIXED_DATE_ENTITY_NAME];
		fixedEndDate.date = [NSDate date];
		sharedVals.defaultFixedSimEndDate = fixedEndDate;

		
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
