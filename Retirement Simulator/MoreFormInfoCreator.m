//
//  MoreFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MoreFormInfoCreator.h"

#import "InputFormPopulator.h"
#import "LocalizationHelper.h"
#import "SectionInfo.h"
#import "StaticNavFieldEditInfo.h"
#import "HelpViewFactory.h"
#import "GenericFieldBasedTableEditViewControllerFactory.h"
#import "HelpRecipesFormInfoCreator.h"

@implementation MoreFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] initForNewObject:FALSE
		andParentController:parentController] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"MORE_VIEW_TITLE");
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"MORE_HELP_SECTION_TITLE");

	HelpRecipesFormInfoCreator *helpRecipeFormInfo = 
		[[[HelpRecipesFormInfoCreator alloc] init] autorelease];
	StaticNavFieldEditInfo *helpRecipeFieldEditInfo = 
		[[[StaticNavFieldEditInfo alloc] 
			initWithCaption:LOCALIZED_STR(@"MORE_RECIPES_TITLE")
			andSubtitle:LOCALIZED_STR(@"MORE_RECIPES_SUBTITLE") 
			andContentDescription:nil
			andSubFormInfoCreator:helpRecipeFormInfo] autorelease];
	[sectionInfo addFieldEditInfo:helpRecipeFieldEditInfo];


	return formPopulator.formInfo;
	
}


@end
