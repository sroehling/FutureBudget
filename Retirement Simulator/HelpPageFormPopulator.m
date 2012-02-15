//
//  HelpPageFormPopulator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpPageFormPopulator.h"

#import "StaticNavFieldEditInfo.h"

#import "HelpPageInfo.h"
#import "HelpViewFactory.h"
#import "StringValidation.h"
#import "SectionInfo.h"
#import "FormContext.h"


@implementation HelpPageFormPopulator

-(void)populateHelpPageWithTitle:(NSString*)pageTitle andPageRef:(NSString*)pageRef
{
	assert([StringValidation nonEmptyString:pageTitle]);
	assert([StringValidation nonEmptyString:pageRef]);

	HelpPageInfo *helpPageInfo = [[[HelpPageInfo alloc] 
		initWithParentController:self.formContext.parentController 
		andHelpPageHTML:pageRef] autorelease];
	HelpViewFactory *helpViewFactory = [[[HelpViewFactory alloc] 
		initWithHelpPageInfo:helpPageInfo] autorelease];
		
	StaticNavFieldEditInfo *helpRecipeFieldEditInfo = 
		[[[StaticNavFieldEditInfo alloc] 
			initWithCaption:pageTitle
			andSubtitle:nil 
			andContentDescription:nil
			andSubViewFactory:helpViewFactory] autorelease];

	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:helpRecipeFieldEditInfo];
}



@end
