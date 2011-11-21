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
#import "Cash.h"
#import "FixedValue.h"

NSString * const SHARED_APP_VALUES_ENTITY_NAME = @"SharedAppValues";
NSString * const SHARED_APP_VALUES_CURRENT_INPUT_SCENARIO_KEY = @"currentInputScenario";
NSString * const SHARED_APP_VALUES_SIM_START_DATE_KEY = @"simStartDate";
NSString * const SHARED_APP_VALUES_SIM_END_DATE_KEY = @"simEndDate";
NSString * const SHARED_APP_VALUES_DEFAULT_FIXED_SIM_END_DATE_KEY = @"defaultFixedSimEndDate";
NSString * const SHARED_APP_VALUES_DEFAULT_RELATIVE_SIM_END_DATE_KEY = @"defaultFixedRelativeEndDate";

#define DEFAULT_SIM_END_DATE_OFFSET_YEARS 50
#define DEFAULT_DEFICIT_INTEREST_RATE 0.0

@implementation SharedAppValues

@dynamic sharedNeverEndDate;
@dynamic defaultScenario;
@dynamic currentInputScenario;
@dynamic repeatOnceFreq;
@dynamic repeatMonthlyFreq;
@dynamic simStartDate;
@dynamic simEndDate;
@dynamic defaultFixedSimEndDate;
@dynamic defaultFixedRelativeEndDate;
@dynamic cash;
@dynamic deficitInterestRate;

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

+(SharedAppValues*)createWithDataModelInterface:(id<DataModelInterface>)dataModelInterface
{

	EventRepeatFrequency *repeatOnce = 
		[EventRepeatFrequency createInDataModel:dataModelInterface 
			andPeriod:kEventPeriodOnce andMultiplier:1];
	[EventRepeatFrequency createInDataModel:dataModelInterface 
			andPeriod:kEventPeriodWeek andMultiplier:1];
	[EventRepeatFrequency createInDataModel:dataModelInterface 
			andPeriod:kEventPeriodWeek andMultiplier:2];
	EventRepeatFrequency *repeatMonthly = [EventRepeatFrequency createInDataModel:dataModelInterface 
			andPeriod:kEventPeriodMonth andMultiplier:1];
	[EventRepeatFrequency createInDataModel:dataModelInterface 
			andPeriod:kEventPeriodMonth andMultiplier:3];
	[EventRepeatFrequency createInDataModel:dataModelInterface 
			andPeriod:kEventPeriodMonth andMultiplier:6];
	[EventRepeatFrequency createInDataModel:dataModelInterface 
			andPeriod:kEventPeriodYear andMultiplier:1];        

	SharedAppValues *sharedVals = [dataModelInterface createDataModelObject:SHARED_APP_VALUES_ENTITY_NAME];
	
	NeverEndDate *theNeverEndDate = [dataModelInterface createDataModelObject:NEVER_END_DATE_ENTITY_NAME];
	theNeverEndDate.date = [DateHelper dateFromStr:NEVER_END_PSEUDO_END_DATE];
	sharedVals.sharedNeverEndDate = theNeverEndDate;
	
	DefaultScenario *defaultScenario = (DefaultScenario*)[dataModelInterface createDataModelObject:DEFAULT_SCENARIO_ENTITY_NAME];
	sharedVals.defaultScenario = defaultScenario;
	sharedVals.currentInputScenario = defaultScenario;
	
	sharedVals.repeatOnceFreq = repeatOnce;
	sharedVals.repeatMonthlyFreq = repeatMonthly;
	
	sharedVals.simStartDate = [[[NSDate alloc] init] autorelease];
	
	RelativeEndDate *theSimEndDate = [dataModelInterface createDataModelObject:RELATIVE_END_DATE_ENTITY_NAME];
	theSimEndDate.years = [NSNumber numberWithInt:DEFAULT_SIM_END_DATE_OFFSET_YEARS];
	theSimEndDate.months = [NSNumber numberWithInt:0];
	theSimEndDate.weeks = [NSNumber numberWithInt:0];
	sharedVals.simEndDate = theSimEndDate;
	sharedVals.defaultFixedRelativeEndDate = theSimEndDate;

	
	FixedDate *fixedEndDate = (FixedDate*)[dataModelInterface createDataModelObject:FIXED_DATE_ENTITY_NAME];
	fixedEndDate.date = [NSDate date];
	sharedVals.defaultFixedSimEndDate = fixedEndDate;
	
	
	Cash *theCash = (Cash*)[dataModelInterface createDataModelObject:CASH_ENTITY_NAME];
	theCash.startingBalance = [NSNumber numberWithDouble:0.0];
	sharedVals.cash = theCash;
	
	FixedValue *theDeficitInterestRate = (FixedValue*)[dataModelInterface createDataModelObject:FIXED_VALUE_ENTITY_NAME];
	theDeficitInterestRate.value = [NSNumber numberWithDouble:DEFAULT_DEFICIT_INTEREST_RATE];
	sharedVals.deficitInterestRate = theDeficitInterestRate;

	return sharedVals;
}

+(void)initFromDatabase
{
    NSLog(@"Initializing database with default data ...");
    
    
    if(![[DataModelController theDataModelController] entitiesExistForEntityName:SHARED_APP_VALUES_ENTITY_NAME])
	{
		NSLog(@"Initializing shared values ...");

		SharedAppValues *sharedVals = [SharedAppValues createWithDataModelInterface:[DataModelController theDataModelController]];
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


-(NSDate*)beginningOfSimStartDate
{
	return [DateHelper beginningOfDay:self.simStartDate];
}



@end
