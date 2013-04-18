//
//  ScenarioListFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScenarioListFormInfoCreator.h"
#import "FormPopulator.h"
#import "LocalizationHelper.h"
#import "Scenario.h"
#import "DataModelController.h"
#import "ScenarioListObjectAdder.h"
#import "SectionInfo.h"
#import "UserScenario.h"
#import "UserScenarioFieldEditInfo.h"
#import "DefaultScenarioFieldEditInfo.h"
#import "DefaultScenario.h"
#import "SharedAppValues.h"
#import "SectionHeaderWithSubtitle.h"
#import "SectionInfo.h"
#import "DefaultScenarioFieldEditInfo.h"
#import "FormContext.h"

@implementation ScenarioListFormInfoCreator

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
    FormPopulator *formPopulator = [[[FormPopulator alloc]
		initWithFormContext:parentContext] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"SCENARIO_LIST_VIEW_TITLE");
	formPopulator.formInfo.objectAdder = [[[ScenarioListObjectAdder alloc] init] autorelease];
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	
	DefaultScenario *defaultScen = 
	      [SharedAppValues getUsingDataModelController:parentContext.dataModelController].defaultScenario;
	StaticFieldEditInfo *defaultScenarioFieldEditInfo = 
		[[[DefaultScenarioFieldEditInfo alloc] initWithDefaultScen:defaultScen] autorelease];
	[sectionInfo addFieldEditInfo:defaultScenarioFieldEditInfo];
	
	sectionInfo = [formPopulator 
		nextSectionWithTitle:LOCALIZED_STR(@"SCENARIO_LIST_ALTERNATE_SCENARIOS_SECTION_TITLE") 
		andHelpFile:@"scenario" andAnchorWithinHelpFile:@"alternate-scenarios"];
	sectionInfo.sectionHeader.addButtonDelegate = [[[ScenarioListObjectAdder alloc] init] autorelease];
	
	NSArray *userScenarios = [parentContext.dataModelController
			fetchSortedObjectsWithEntityName:USER_SCENARIO_ENTITY_NAME 
			sortKey:USER_SCENARIO_NAME_KEY];
	for (UserScenario *userScen in userScenarios)
	{
		UserScenarioFieldEditInfo *userScenFieldEditInfo = 
			[[[UserScenarioFieldEditInfo alloc] initWithUserScenario:userScen] autorelease];
		[sectionInfo addFieldEditInfo:userScenFieldEditInfo];
	}
	return formPopulator.formInfo;
	
}

@end
