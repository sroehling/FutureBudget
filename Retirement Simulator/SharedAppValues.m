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
#import "CoreDataHelper.h"
#import "TransferEndpointCash.h"

NSString * const SHARED_APP_VALUES_ENTITY_NAME = @"SharedAppValues";
NSString * const SHARED_APP_VALUES_CURRENT_INPUT_SCENARIO_KEY = @"currentInputScenario";
NSString * const SHARED_APP_VALUES_SIM_START_DATE_KEY = @"simStartDate";
NSString * const SHARED_APP_VALUES_SIM_END_DATE_KEY = @"simEndDate";
NSString * const SHARED_APP_VALUES_DEFAULT_FIXED_SIM_END_DATE_KEY = @"defaultFixedSimEndDate";
NSString * const SHARED_APP_VALUES_DEFAULT_RELATIVE_SIM_END_DATE_KEY = @"defaultFixedRelativeEndDate";
NSString * const SHARED_APP_VALUES_ADJUST_RESULTS_FOR_INFLATION_KEY = @"adjustResultsForSimStartDate";
NSString * const SHARED_APP_VALUES_STARTING_DEFICIT_BALANCE_KEY = @"deficitStartingBal";

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
@dynamic repeatYearlyFreq;
@dynamic adjustResultsForSimStartDate; 
@dynamic deficitStartingBal;


+(void)createDefaultVariableValue:(double)startingVal withLabelStringFileKey:(NSString*)labelKey
	usingDataModelInterface:(id<DataModelInterface>)dataModelInterface andEntityName:(NSString*)entityName
	andDisplayOrder:(NSUInteger)displayOrder
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
	defaultVal.displayOrder = [NSNumber numberWithUnsignedInteger:displayOrder];
	
}

+(void)createDefaultInvestmentReturn:(double)yearlyReturn withLabelStringFileKey:(NSString*)labelKey
	usingDataModelInterface:(id<DataModelInterface>)dataModelInterface
	andDisplayOrder:(NSUInteger)displayOrder
{
	return [SharedAppValues createDefaultVariableValue:yearlyReturn 
		withLabelStringFileKey:labelKey 
		usingDataModelInterface:dataModelInterface andEntityName:INVESTMENT_RETURN_RATE_ENTITY_NAME
		andDisplayOrder:displayOrder];
}

+(void)createDefaultLoanDownPmt:(double)downPmtPercent withLabelStringFileKey:(NSString*)labelKey
	usingDataModelInterface:(id<DataModelInterface>)dataModelInterface
	andDisplayOrder:(NSUInteger)displayOrder
{
	return [SharedAppValues createDefaultVariableValue:downPmtPercent 
		withLabelStringFileKey:labelKey 
		usingDataModelInterface:dataModelInterface andEntityName:LOAN_DOWN_PMT_PERCENT_ENTITY_NAME
		andDisplayOrder:displayOrder];
	
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
	EventRepeatFrequency *repeatYearly = [EventRepeatFrequency createInDataModel:dataModelInterface 
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
	sharedVals.repeatYearlyFreq = repeatYearly;
	
	sharedVals.simStartDate = [[[NSDate alloc] init] autorelease];
	
	RelativeEndDate *theSimEndDate = [dataModelInterface createDataModelObject:RELATIVE_END_DATE_ENTITY_NAME];
	theSimEndDate.monthsOffset = [NSNumber numberWithInt:DEFAULT_SIM_END_DATE_OFFSET_YEARS*12];
	sharedVals.simEndDate = theSimEndDate;
	sharedVals.defaultFixedRelativeEndDate = theSimEndDate;

	
	FixedDate *fixedEndDate = (FixedDate*)[dataModelInterface createDataModelObject:FIXED_DATE_ENTITY_NAME];
	fixedEndDate.date = [NSDate date];
	sharedVals.defaultFixedSimEndDate = fixedEndDate;
	
	
	Cash *theCash = (Cash*)[dataModelInterface createDataModelObject:CASH_ENTITY_NAME];
	theCash.startingBalance = [NSNumber numberWithDouble:0.0];
	sharedVals.cash = theCash;
	
	TransferEndpointCash *cashTransferEndpoint = (TransferEndpointCash *)[dataModelInterface 
			createDataModelObject:TRANSFER_ENDPOINT_CASH_ENTITY_NAME];
	cashTransferEndpoint.cash = theCash;
	
	
	sharedVals.defaultInflationRate = (InflationRate*)
		[dataModelInterface createDataModelObject:INFLATION_RATE_ENTITY_NAME];
	sharedVals.defaultInflationRate.startingValue = [NSNumber numberWithDouble:DEFAULT_INFLATION_RATE];
	sharedVals.defaultInflationRate.isDefault = [NSNumber numberWithBool:TRUE];
	sharedVals.defaultInflationRate.staticNameStringFileKey = @"DEFAULT_INFLATION_RATE_LABEL";
	sharedVals.defaultInflationRate.name = @"N/A";	
	
	sharedVals.adjustResultsForSimStartDate = [NSNumber numberWithBool:TRUE];
	
	[SharedAppValues createDefaultInvestmentReturn:DEFAULT_ROI_SAVINGS 
		withLabelStringFileKey:@"DEFAULT_ROI_SAVINGS_INTEREST_LABEL" 
		usingDataModelInterface:dataModelInterface
		andDisplayOrder:1];
	[SharedAppValues createDefaultInvestmentReturn:DEFAULT_ROI_LOW 
		withLabelStringFileKey:@"DEFAULT_ROI_LOW_RISK_LABEL" 
		usingDataModelInterface:dataModelInterface
		andDisplayOrder:2];
	[SharedAppValues createDefaultInvestmentReturn:DEFAULT_ROI_MEDIUM
		withLabelStringFileKey:@"DEFAULT_ROI_MEDIUM_RISK_LABEL" 
		usingDataModelInterface:dataModelInterface
		andDisplayOrder:3];
	[SharedAppValues createDefaultInvestmentReturn:DEFAULT_ROI_AGGRESSIVE
		withLabelStringFileKey:@"DEFAULT_ROI_AGGRESSIVE_LABEL" 
		usingDataModelInterface:dataModelInterface
		andDisplayOrder:4];
		
	[SharedAppValues createDefaultLoanDownPmt:DEFAULT_LOAN_DOWN_PMT_NOTHING_DOWN 
		withLabelStringFileKey:@"DEFAULT_LOAN_DOWN_PMT_NOTHING_DOWN" 
		usingDataModelInterface:dataModelInterface
		andDisplayOrder:1];
	[SharedAppValues createDefaultLoanDownPmt:DEFAULT_LOAN_DOWN_PMT_10PERC_DOWN 
		withLabelStringFileKey:@"DEFAULT_LOAN_DOWN_PMT_10PERC_DOWN" 
		usingDataModelInterface:dataModelInterface
		andDisplayOrder:2];
	[SharedAppValues createDefaultLoanDownPmt:DEFAULT_LOAN_DOWN_PMT_20PERC_DOWN 
		withLabelStringFileKey:@"DEFAULT_LOAN_DOWN_PMT_20PERC_DOWN" 
		usingDataModelInterface:dataModelInterface
		andDisplayOrder:3];
	
	FixedValue *theDeficitInterestRate = (FixedValue*)[dataModelInterface createDataModelObject:FIXED_VALUE_ENTITY_NAME];
	theDeficitInterestRate.value = [NSNumber numberWithDouble:DEFAULT_DEFICIT_INTEREST_RATE];
	sharedVals.deficitInterestRate = theDeficitInterestRate;
	sharedVals.deficitStartingBal = [NSNumber numberWithDouble:0.0];

	return sharedVals;
}

+(void)initFromDatabase
{
    NSLog(@"Initializing database with default data ...");
    
	
	DataModelController *dmcForInit = [[[DataModelController alloc] init] autorelease];
	
    
    if(![dmcForInit entitiesExistForEntityName:SHARED_APP_VALUES_ENTITY_NAME])
	{
		NSLog(@"Initializing shared values ...");

		[SharedAppValues createWithDataModelInterface:dmcForInit];
		[dmcForInit saveContext];

	}
        
}


+(SharedAppValues*)getUsingDataModelController:(DataModelController*)dataModelController
{
	SharedAppValues *theAppValues = (SharedAppValues*)[CoreDataHelper fetchSingleObjectForEntityName:SHARED_APP_VALUES_ENTITY_NAME 
		inManagedObectContext:dataModelController.managedObjectContext];
	assert(theAppValues != nil);
	return theAppValues;
}



-(NSDate*)beginningOfSimStartDate
{
	return [DateHelper beginningOfDay:self.simStartDate];
}



@end
