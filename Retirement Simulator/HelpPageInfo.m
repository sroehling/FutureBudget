//
//  HelpPageInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpPageInfo.h"
#import "StringValidation.h"


@implementation HelpPageInfo

@synthesize parentController;
@synthesize helpPageHTML;

-(id)initWithParentController:(UIViewController*)theParentController
	andHelpPageHTML:(NSString*)helpHTML
{
	self = [super init];
	if(self)
	{
		assert(theParentController != nil);
		self.parentController = theParentController;
		
		assert([StringValidation nonEmptyString:helpHTML]);
		self.helpPageHTML = helpHTML;
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
	[super dealloc];
	[helpPageHTML release];
}



@end
