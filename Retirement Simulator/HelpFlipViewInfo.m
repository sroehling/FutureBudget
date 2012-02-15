//
//  HelpFlipViewInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpFlipViewInfo.h"
#import "StringValidation.h"


@implementation HelpFlipViewInfo

@synthesize parentController;
@synthesize helpPageHTMLFile;

-(id)initWithParentController:(UIViewController*)theParentController
	andHelpPageHTMLFile:(NSString*)helpHTML
{
	self = [super init];
	if(self)
	{
		assert(theParentController != nil);
		self.parentController = theParentController;
		
		assert([StringValidation nonEmptyString:helpHTML]);
		self.helpPageHTMLFile = helpHTML;
		
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(void)dealloc
{
	[helpPageHTMLFile release];
	[super dealloc];
}



@end
