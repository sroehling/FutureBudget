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
#import "FormContext.h"
#import "BoolFieldEditInfo.h"
#import "PasscodeFieldInfo.h"
#import "RateAppFieldEditInfo.h"

@implementation MoreFormInfoCreator

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
    HelpPageFormPopulator *formPopulator = [[[HelpPageFormPopulator alloc] 
		initWithFormContext:parentContext] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"MORE_VIEW_TITLE");
	
	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"MORE_HELP_SECTION_TITLE")];

	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_GETTING_STARTED") 
		andPageRef:@"gettingStarted"];

	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"MORE_EXAMPLES_TITLE")
		andSubTitle:LOCALIZED_STR(@"MORE_EXAMPLES_SUBTITLE")
		andPageRef:@"example"];
		
	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"MORE_APP_INFO_SECTION_TITLE")];
		
		
	[formPopulator populateHelpPageWithTitle:LOCALIZED_STR(@"HELP_ABOUT") andPageRef:@"about"];

	[formPopulator.currentSection addFieldEditInfo:[[[RateAppFieldEditInfo alloc] init] autorelease]];
		
	[formPopulator nextSection];
	PasscodeFieldInfo *passcodeFieldInfo  = [[[PasscodeFieldInfo alloc] 
				initWithParentController:parentContext.parentController] autorelease];
	BoolFieldEditInfo *passcodeFieldEditInfo = 
		[[[BoolFieldEditInfo alloc] 
			initWithFieldInfo: passcodeFieldInfo
			andSubtitle:nil] autorelease];
	[formPopulator.currentSection addFieldEditInfo:passcodeFieldEditInfo];



	return formPopulator.formInfo;
	
}


@end
