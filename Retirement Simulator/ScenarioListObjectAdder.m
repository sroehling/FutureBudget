//
//  ScenarioListObjectAdder.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScenarioListObjectAdder.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "UserScenarioFormInfoCreator.h"
#import "UserScenario.h"
#import "DataModelController.h"
#import "FormContext.h"


@implementation ScenarioListObjectAdder


-(void)addObjectFromTableView:(FormContext*)parentContext
{

	// TODO - Allocate a new DataModelController, so that new scenarios are saved, even
	// if the parent's object creation is canceled.

	UserScenario *newScenario = [parentContext.dataModelController insertObject:USER_SCENARIO_ENTITY_NAME];
	newScenario.iconImageName = SCENARIO_DEFAULT_ICON_IMAGE_NAME;
	UserScenarioFormInfoCreator *scenarioFormCreator = 
		[[[UserScenarioFormInfoCreator alloc] initWithUserScenario:newScenario] autorelease];

    GenericFieldBasedTableAddViewController *controller = [[[GenericFieldBasedTableAddViewController alloc]
		initWithFormInfoCreator:scenarioFormCreator
			andNewObject:newScenario 
			andDataModelController:parentContext.dataModelController] autorelease];
    controller.popDepth =1;
	assert(controller.popDepth == 1);

    [parentContext.parentController.navigationController pushViewController:controller animated:YES];
}

-(void)addButtonPressedInSectionHeader:(FormContext*)parentContext
{
	return [self addObjectFromTableView:parentContext];
}

-(BOOL)supportsAddOutsideEditMode
{
	return FALSE;
}



@end
