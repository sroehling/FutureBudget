//
//  ScenarioNameValidator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/7/13.
//
//

#import "ScenarioNameValidator.h"
#import "LocalizationHelper.h"
#import "DataModelController.h"
#import "UserScenario.h"
#import "CoreDataHelper.h"

@implementation ScenarioNameValidator

@synthesize currentScenario;
@synthesize otherScenarioNames;

-(void)dealloc
{
	[currentScenario release];
	[otherScenarioNames release];
	[super dealloc];
}

-(id)initWithScenario:(UserScenario *)theCurrentScenario andDataModelController:(DataModelController*)theDmc
{
	self = [super initWithValidationMsg:LOCALIZED_STR(@"SCENARIO_NAME_VALIDATION_MSG")];
	if(self)
	{
		assert(theCurrentScenario != nil);
		self.currentScenario = theCurrentScenario;
		
		self.otherScenarioNames = [[[NSMutableSet alloc] init] autorelease];
		NSSet *allScenarios = [theDmc fetchObjectsForEntityName:USER_SCENARIO_ENTITY_NAME];
		for(UserScenario *scenario in allScenarios)
		{
			if(![CoreDataHelper sameCoreDataObjects:self.currentScenario comparedTo:scenario])
			{
				[self.otherScenarioNames addObject:scenario.name];
			}
		}
		// Scenarios also can't have the same name as the default scenario
		[self.otherScenarioNames addObject:LOCALIZED_STR(@"SCENARIO_DEFAULT_SCENARIO_NAME")];
		
		
	}
	return self;
}

-(BOOL)validateText:(NSString *)theText
{
	if(theText.length == 0)
	{
		return FALSE;
	}

	if([self.otherScenarioNames member:theText])
	{
		return FALSE;
	}
	
	return TRUE;
}



@end
