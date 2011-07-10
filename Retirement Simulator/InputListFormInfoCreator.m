//
//  InputListFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputListFormInfoCreator.h"
#import "FormPopulator.h"
#import "Input.h"
#import "DataModelController.h"
#import "InputFieldEditInfo.h"
#import "SectionInfo.h"
#import "InputListObjectAdder.h"
#import "TableHeaderWithDisclosure.h"
#import "SharedAppValues.h"
#import "Scenario.h"
#import "LocalizationHelper.h"
#import "SelectScenarioTableHeaderButtonDelegate.h"

@implementation InputListFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = @"Inputs";
	formPopulator.formInfo.objectAdder = [[[InputListObjectAdder alloc] init] autorelease];
	
	
	SelectScenarioTableHeaderButtonDelegate *scenarioListDisclosureDelegate = 
		[[[SelectScenarioTableHeaderButtonDelegate alloc] initWithParentController:parentController] autorelease];
	
	TableHeaderWithDisclosure *tableHeader = 
		[[[TableHeaderWithDisclosure alloc] initWithFrame:CGRectZero andDisclosureButtonDelegate:scenarioListDisclosureDelegate] autorelease];
	tableHeader.header.text = [NSString 
		stringWithFormat:LOCALIZED_STR(@"INPUT_LIST_TABLE_HEADER_FORMAT"),
		[SharedAppValues singleton].currentInputScenario.scenarioName];
	[tableHeader resizeForChildren];
	formPopulator.formInfo.headerView = tableHeader;
	
	SectionInfo *sectionInfo = [formPopulator nextSection];

	NSArray *inputs = [[DataModelController theDataModelController]
								   fetchSortedObjectsWithEntityName:@"Input" sortKey:@"name"];
	for (Input *input in inputs)
	{
		// Create the row information for the given milestone date.
		InputFieldEditInfo *inputFieldEditInfo =
			[[[InputFieldEditInfo alloc] initWithInput:input] autorelease];
		[sectionInfo addFieldEditInfo:inputFieldEditInfo];
	}
	return formPopulator.formInfo;
	
}

@end
