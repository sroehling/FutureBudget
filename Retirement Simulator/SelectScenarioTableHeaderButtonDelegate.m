//
//  SelectScenarioTableHeaderButtonDelegate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectScenarioTableHeaderButtonDelegate.h"
#import "SharedAppValues.h"
#import "ManagedObjectFieldInfo.h"
#import "ScenarioListFormInfoCreator.h"
#import "FormContext.h"
#import "SelectableObjectTableEditViewController.h"


@implementation SelectScenarioTableHeaderButtonDelegate

@synthesize formContext;

-(id)initWithFormContext:(FormContext*)theFormContext
{
	self = [super init];
	if(self)
	{
		assert(theFormContext != nil);
		self.formContext = theFormContext;
	}
	return self;
}

-(id) init 
{
	assert(0); // must call init with parent controller
	return nil;
}

- (void)tableHeaderDisclosureButtonPressed
{
	SharedAppValues *theSharedAppValues = [SharedAppValues getUsingDataModelController:self.formContext.dataModelController];
	
	ManagedObjectFieldInfo *currentScenarioFieldInfo = 
		[[[ManagedObjectFieldInfo alloc] initWithManagedObject:theSharedAppValues andFieldKey:SHARED_APP_VALUES_CURRENT_INPUT_SCENARIO_KEY 
			andFieldLabel:@"dummy" andFieldPlaceholder:@"dummy"] autorelease];
	ScenarioListFormInfoCreator *scenarioFormInfoCreator = 
		[[[ScenarioListFormInfoCreator alloc] init] autorelease];
		
	SelectableObjectTableEditViewController *scenarioController = 
		[[SelectableObjectTableEditViewController alloc]
		initWithFormInfoCreator:scenarioFormInfoCreator andAssignedField:currentScenarioFieldInfo
		andDataModelController:self.formContext.dataModelController];

	scenarioController.closeAfterSelection = TRUE;
	[self.formContext.parentController.navigationController pushViewController:scenarioController animated:YES];
	
	[scenarioController release];

}

- (void) dealloc
{
	[formContext release];
	[super dealloc];
}

@end
