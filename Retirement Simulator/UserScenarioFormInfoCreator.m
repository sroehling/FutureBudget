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
#import "TextFieldEditInfo.h"
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
    [sectionInfo addFieldEditInfo:[TextFieldEditInfo createForObject:self.userScen andKey:USER_SCENARIO_NAME_KEY 
			andLabel:LOCALIZED_STR(@"SCENARIO_NAME_FIELD_LABEL")
			andPlaceholder:LOCALIZED_STR(@"SCENARIO_NAME_PLACEHOLDER")]];
	
	return formPopulator.formInfo;
	
}

-(void) dealloc
{
	[super dealloc];
	[userScen release];
}


@end
