//
//  HelpPagePopoverCaptionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpPagePopoverCaptionInfo.h"
#import "StringValidation.h"
#import "HelpFlipViewInfo.h"
#import "HelpInfoViewFlipViewController.h"


@implementation HelpPagePopoverCaptionInfo

@synthesize helpPageMoreInfoCaption;
@synthesize popoverCaption;
@synthesize helpPageName;
@synthesize parentController;

-(id)initWithPopoverCaption:(NSString*)thePopoverCaption
	andHelpPageMoreInfoCaption:(NSString*)moreInfoCaption
	andHelpPageName:(NSString*)theHelpPageName
	andParentController:(UIViewController*)theParentController;

{
	self = [super init];
	if(self)
	{
		assert([StringValidation nonEmptyString:thePopoverCaption]);
		assert([StringValidation nonEmptyString:moreInfoCaption]);
		assert([StringValidation nonEmptyString:theHelpPageName]);
		
		self.popoverCaption = thePopoverCaption;
		self.helpPageMoreInfoCaption = moreInfoCaption;
		self.helpPageName = theHelpPageName;
		
		assert(theParentController != nil);
		self.parentController = theParentController;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(void)moreInfoButtonPressed
{
	HelpFlipViewInfo *flipViewInfo = [[[HelpFlipViewInfo alloc] 
			initWithParentController:self.parentController 
			andHelpPageHTMLFile:self.helpPageName] autorelease];
	
	HelpInfoViewFlipViewController *helpInfoViewController = [[[HelpInfoViewFlipViewController alloc] 
		initWithHelpFlipViewInfo:flipViewInfo] autorelease];
	[parentController presentModalViewController:helpInfoViewController animated:TRUE];

}

-(void)dealloc
{
	[helpPageMoreInfoCaption release];
	[helpPageName release];
	[popoverCaption release];
	[super dealloc];
}

@end
