//
//  HelpRecipesFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpRecipesFormInfoCreator.h"

#import "LocalizationHelper.h"
#import "SectionInfo.h"
#import "StaticNavFieldEditInfo.h"
#import "HelpViewFactory.h"
#import "HelpPageInfo.h"
#import "HelpPageFormPopulator.h"

@implementation HelpRecipesFormInfoCreator


- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    HelpPageFormPopulator *formPopulator = [[[HelpPageFormPopulator alloc] 
		initWithParentController:parentController] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"MORE_RECIPES_TITLE");
	

	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"HELP_RECIPES_EXPENSES_SECTION_TITLE");
	
	[formPopulator populateHelpPageWithTitle:LOCALIZED_STR(@"HELP_RECIPES_EXPENSES_ONE_TIME_EXPENSE_TITLE") andPageRef:@"recipeOneTimeExpense"];


	return formPopulator.formInfo;
	
}


@end
