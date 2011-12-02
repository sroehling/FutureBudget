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
#import "InflationRate.h"
#import "InterestRate.h"
#import "InvestmentReturnRate.h"
#import "StringValidation.h"
#import "LoanDownPmtPercent.h"

NSString * const SHARED_APP_VALUES_ENTITY_NAME = @"SharedAppValues";
NSString * const SHARED_APP_VALUES_CURRENT_INPUT_SCENARIO_KEY = @"currentInputScenario";
NSString * const SHARED_APP_VALUES_SIM_START_DATE_KEY = @"simStartDate";
NSString * const SHARED_APP_VALUES_SIM_END_DATE_KEY = @"simEndDate";
NSString * const SHARED_APP_VALUES_DEFAULT_FIXED_SIM_END_DATE_KEY = @"defaultFixedSimEndDate";
NSString * const SHARED_APP_VALUES_DEFAULT_RELATIVE_SIM_END_DATE_KEY = @"defaultFixedRelativeEndDate";

#define DEFAULT_SIM_END_DATE_OFFSET_YEARS 50
#define DEFAULT_DEFICIT_INTEREST_RATE 0.0
#define DEFAULT_INFLATION_RATE 3.0
#define DEFAULT_ROI_LOW 5.0
#define DEFAULT_ROI_MEDIUM 7.5
#define DEFAULT_ROI_AGGRESSIVE 10.0
#define DEFAULT_ROI_SAVINGS 1.0

#define DEFAULT_LOAN_DOWN_PMT_NOTHING_DOWN 0.0
#define DEFAULT_LOAN_DOWN_PMT_10PERC_DOWN 10.0
#define DEFAULT_LOAN_DOWN_PMT_20PERC_DOWN 20.0

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
@dynamic defaultInflationRate;


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

+(void)createDefaultVariableValue:(double)startingVal withLabelStringFileKey:(NSString*)labelKey
	usingDataModelInterface:(id<DataModelInterface>)dataModelInterface andEntityName:(NSString*)entityName
{
	assert([StringValidation nonEmptyString:entityName]);
	assert([StringValidation nonEmptyString:labelKey]);
	assert(dataModelInterface != nil);

	VariableValue *defaultVal = (VariableValue*)[dataModelInterface createDataModelObject:entityName];
	assert(defaultVal != nil);
	defaultVal.isDefault = [NSNumber numberWithBool:FALSE];
	defaultVal.staticNameStringFileKey = labelKey;
	defaultVal.name = @"N/A";
	defaultVal.startingValue = [NSNumber numberWithDouble:startingVal];
	
}

+(void)createDefaultInvestmentReturn:(double)yearlyReturn withLabelStringFileKey:(NSString*)labelKey
	usingDataModelInterface:(id<DataModelInterface>)dataModelInterface
{
	return [SharedAppValues createDefaultVariableValue:yearlyReturn 
		withLabelStringFileKey:labelKey 
		usingDataModelInterface:dataModelInterface andEntityName:INVESTMENT_RETURN_RATE_ENTITY_NAME];
}

+(void)createDefaultLoanDownPmt:(double)downPmtPercent withLabelStringFileKey:(NSString*)labelKey
	usingDataModelInterface:(id<DataModelInterface>)dataModelInterface
{
	return [SharedAppValues createDefaultVariableValue:downPmtPercent 
		withLabelStringFileKey:labelKey 
		usingDataModelInterface:dataModelInterface andEntityName:LOAN_DOWN_PMT_PERCENT_ENTITY_NAME];
	
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
	
	sharedVals.defaultInflationRate = (InflationRate*)
		[dataModelInterface createDataModelObject:INFLATION_RATE_ENTITY_NAME];
	sharedVals.defaultInflationRate.startingValue = [NSNumber numberWithDouble:DEFAULT_INFLATION_RATE];
	sharedVals.defaultInflationRate.isDefault = [NSNumber numberWithBool:TRUE];
	sharedVals.defaultInflationRate.staticNameStringFileKey = @"DEFAULT_INFLATION_RATE_LABEL";
	sharedVals.defaultInflationRate.name = @"N/A";	
	
	[SharedAppValues createDefaultInvestmentReturn:DEFAULT_ROI_LOW 
		withLabelStringFileKey:@"DEFAULT_ROI_LOW_RISK_LABEL" 
		usingDataModelInterface:dataModelInterface];
	[SharedAppValues createDefaultInvestmentReturn:DEFAULT_ROI_MEDIUM
		withLabelStringFileKey:@"DEFAULT_ROI_MEDIUM_RISK_LABEL" 
		usingDataModelInterface:dataModelInterface];
	[SharedAppValues createDefaultInvestmentReturn:DEFAULT_ROI_AGGRESSIVE
		withLabelStringFileKey:@"DEFAULT_ROI_AGGRESSIVE_LABEL" 
		usingDataModelInterface:dataModelInterface];
	[SharedAppValues createDefaultInvestmentReturn:DEFAULT_ROI_SAVINGS 
		withLabelStringFileKey:@"DEFAULT_ROI_SAVINGS_INTEREST_LABEL" 
		usingDataModelInterface:dataModelInterface];
		
	[SharedAppValues createDefaultLoanDownPmt:DEFAULT_LOAN_DOWN_PMT_NOTHING_DOWN 
		withLabelStringFileKey:@"DEFAULT_LOAN_DOWN_PMT_NOTHING_DOWN" 
		usingDataModelInterface:dataModelInterface];
	[SharedAppValues createDefaultLoanDownPmt:DEFAULT_LOAN_DOWN_PMT_10PERC_DOWN 
		withLabelStringFileKey:@"DEFAULT_LOAN_DOWN_PMT_10PERC_DOWN" 
		usingDataModelInterface:dataModelInterface];
	[SharedAppValues createDefaultLoanDownPmt:DEFAULT_LOAN_DOWN_PMT_20PERC_DOWN 
		withLabelStringFileKey:@"DEFAULT_LOAN_DOWN_PMT_20PERC_DOWN" 
		usingDataModelInterface:dataModelInterface];
	
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
