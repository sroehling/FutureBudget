//
//  HelpRecipesFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpRecipesFormInfoCreator.h"

#import "FormPopulator.h"
#import "LocalizationHelper.h"
#import "SectionInfo.h"
#import "StaticNavFieldEditInfo.h"
#import "HelpViewFactory.h"
#import "HelpPageInfo.h"

@implementation HelpRecipesFormInfoCreator

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] 
		initWithParentController:parentController] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"MORE_RECIPES_TITLE");
	

	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"HELP_RECIPES_EXPENSES_SECTION_TITLE");

	HelpPageInfo *helpPageInfo = [[[HelpPageInfo alloc] initWithParentController:parentController andHelpPageHTML:@"recipeOneTimeExpense"] autorelease];
	HelpViewFactory *helpViewFactory = [[[HelpViewFactory alloc] 
		initWithHelpPageInfo:helpPageInfo] autorelease];
	StaticNavFieldEditInfo *helpRecipeFieldEditInfo = 
		[[[StaticNavFieldEditInfo alloc] 
			initWithCaption:LOCALIZED_STR(@"HELP_RECIPES_EXPENSES_ONE_TIME_EXPENSE_TITLE")
			andSubtitle:nil 
			andContentDescription:nil
			andSubViewFactory:helpViewFactory] autorelease];
	[sectionInfo addFieldEditInfo:helpRecipeFieldEditInfo];

	return formPopulator.formInfo;
	
}


@end
