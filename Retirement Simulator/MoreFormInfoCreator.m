//
//  MoreFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MoreFormInfoCreator.h"

#import "HelpPageFormPopulator.h"
#import "LocalizationHelper.h"
#import "SectionInfo.h"
#import "StaticNavFieldEditInfo.h"
#import "HelpViewFactory.h"
#import "GenericFieldBasedTableEditViewControllerFactory.h"
#import "HelpRecipesFormInfoCreator.h"

@implementation MoreFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    HelpPageFormPopulator *formPopulator = [[[HelpPageFormPopulator alloc] 
		initWithParentController:parentController] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"MORE_VIEW_TITLE");
	
	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"MORE_HELP_SECTION_TITLE")];

	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_GETTING_STARTED") 
		andPageRef:@"gettingStarted"];

	[formPopulator populateStaticNavFieldWithFormInfoCreator:
		[[[HelpRecipesFormInfoCreator alloc] init] autorelease] 
		andFieldCaption:LOCALIZED_STR(@"MORE_RECIPES_TITLE") 
		andSubTitle:LOCALIZED_STR(@"MORE_RECIPES_SUBTITLE")];


	return formPopulator.formInfo;
	
}


@end