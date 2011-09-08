//
//  UserScenarioFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserScenarioFormInfoCreator.h"
#import "FormPopulator.h"
#import "LocalizationHelper.h"
#import "UserScenario.h"
#import "NameFieldEditInfo.h"
#import "ManagedObjectFieldInfo.h"
#import "SectionInfo.h"

@implementation UserScenarioFormInfoCreator

@synthesize userScen;

-(id)initWithUserScenario:(UserScenario*)theScenario
{
	self = [super init];
	if(self)
	{
		self.userScen = theScenario;
	}
	return self;
}

- (id) init
{
	assert(0); // must call init above.
	return nil;
}

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"SCENARIO_DETAIL_VIEW_TITLE");
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	
	ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] initWithManagedObject:self.userScen andFieldKey:USER_SCENARIO_NAME_KEY andFieldLabel:LOCALIZED_STR(@"SCENARIO_NAME_FIELD_LABEL") andFieldPlaceholder:LOCALIZED_STR(@"SCENARIO_NAME_PLACEHOLDER")] autorelease];
	NameFieldEditInfo *fieldEditInfo = [[[NameFieldEditInfo alloc] initWithFieldInfo:fieldInfo] autorelease];
	
    [sectionInfo addFieldEditInfo:fieldEditInfo];
	
	return formPopulator.formInfo;
	
}

-(void) dealloc
{
	[super dealloc];
	[userScen release];
}


@end
