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
#import "StaticFieldEditInfo.h"
#import "DefaultScenario.h"
#import "SharedAppValues.h"

@implementation ScenarioListFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] initWithParentController:parentController] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"SCENARIO_LIST_VIEW_TITLE");
	formPopulator.formInfo.objectAdder = [[[ScenarioListObjectAdder alloc] init] autorelease];
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	
	DefaultScenario *defaultScen = 
	      [SharedAppValues singleton].defaultScenario;
	StaticFieldEditInfo *defaultScenarioFieldEditInfo = 
		[[[StaticFieldEditInfo alloc] initWithManagedObj:defaultScen 
		   andCaption:LOCALIZED_STR(@"SCENARIO_LIST_DEFAULT_SCENARIO_CAPTION") andContent:@""] autorelease];
	[sectionInfo addFieldEditInfo:defaultScenarioFieldEditInfo];
	
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"SCENARIO_LIST_ALTERNATE_SCENARIOS_SECTION_TITLE");
	sectionInfo.subTitle = LOCALIZED_STR(@"SCENARIO_LIST_ALTERNATE_SCENARIOS_SECTION_SUBTITLE");
	
	NSArray *userScenarios = [[DataModelController theDataModelController]
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
