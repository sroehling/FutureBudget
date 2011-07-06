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


@implementation ScenarioListObjectAdder

-(void)addObjectFromTableView:(UITableViewController*)parentView
{

	UserScenario *newScenario = [[DataModelController theDataModelController] 
							  insertObject:USER_SCENARIO_ENTITY_NAME];
	UserScenarioFormInfoCreator *scenarioFormCreator = 
		[[[UserScenarioFormInfoCreator alloc] initWithUserScenario:newScenario] autorelease];

    GenericFieldBasedTableAddViewController *controller = [[[GenericFieldBasedTableAddViewController alloc]
		initWithFormInfoCreator:scenarioFormCreator
			andNewObject:newScenario] autorelease];
    controller.popDepth =1;
	assert(controller.popDepth == 1);

    [parentView.navigationController pushViewController:controller animated:YES];

	
}


@end
