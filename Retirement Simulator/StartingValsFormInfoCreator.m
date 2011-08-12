//
//  StartingValsFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StartingValsFormInfoCreator.h"
#import "FormPopulator.h"
#import "SharedAppValues.h"
#import "Input.h"
#import "Account.h"
#import "DataModelController.h"
#import "LocalizationHelper.h"
#import "NumberFieldEditInfo.h"
#import "NumberHelper.h"
#import "SectionInfo.h"
#import "LocalizationHelper.h"
#import "DateFieldEditInfo.h"
#import "SimDateRuntimeInfo.h"
#import "SimDateFieldEditInfo.h"

@implementation StartingValsFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"STARTUP_VALUES_VIEW_TITLE");
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"STARTUP_VALUES_START_DATE_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"STARTUP_VALUES_START_DATE_SECTION_SUBTITLE");
	
	DateFieldEditInfo *simStartDateInfo = 
		[DateFieldEditInfo createForObject:[SharedAppValues singleton] 
            andKey:SHARED_APP_VALUES_SIM_START_DATE_KEY 
			andLabel:LOCALIZED_STR(@"STARTUP_VALS_START_DATE_LABEL")
			andPlaceholder:LOCALIZED_STR(@"STARTUP_VALS_START_DATE_PLACEHOLDER")];	
	[sectionInfo addFieldEditInfo:simStartDateInfo];
	
	
	// TODO - Add support to edit end date.
	SimDateRuntimeInfo *endDateInfo = 
			[[[SimDateRuntimeInfo alloc] 
				initWithTableTitle:LOCALIZED_STR(@"SIM_END_DATE_TABLE_TITLE")
				andHeader:LOCALIZED_STR(@"SIM_END_DATE_TABLE_HEADER")
				andSubHeader:LOCALIZED_STR(@"SIM_END_DATE_TABLE_SUBTITLE") 
				andSupportsNeverEndDate:FALSE] autorelease];
			
			
	SimDateFieldEditInfo *endDateFieldEditInfo = [SimDateFieldEditInfo createForObject:[SharedAppValues singleton] andKey:SHARED_APP_VALUES_SIM_END_DATE_KEY andLabel:LOCALIZED_STR(@"INPUT_CASHFLOW_END_FIELD_LABEL") 
		andDefaultFixedDate:[SharedAppValues singleton].defaultFixedSimEndDate andVarDateRuntimeInfo:endDateInfo
		andShowEndDates:TRUE andDefaultRelEndDateKey:SHARED_APP_VALUES_DEFAULT_RELATIVE_SIM_END_DATE_KEY];

	[sectionInfo addFieldEditInfo:endDateFieldEditInfo];

	
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"STARTUP_VALUES_STARTING_BALANCES_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"STARTUP_VALUES_STARTING_BALANCES_SECTION_SUBTITLE");
	
	NSArray *accounts = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:ACCOUNT_ENTITY_NAME 
			sortKey:INPUT_NAME_KEY];
	for (Account *account in accounts)
	{
		NumberFieldEditInfo *acctBalanceFieldEditInfo = 
			[NumberFieldEditInfo createForObject:account andKey:ACCOUNT_STARTING_BALANCE_KEY andLabel:account.name andPlaceholder:LOCALIZED_STR(@"INPUT_ACCOUNT_STARTING_BALANCE_PLACEHOLDER") andNumberFormatter:[NumberHelper theHelper].currencyFormatter];
		[sectionInfo addFieldEditInfo:acctBalanceFieldEditInfo];
	}
	return formPopulator.formInfo;
	
}

@end
