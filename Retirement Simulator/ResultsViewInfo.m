//
//  ResultsViewInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultsViewInfo.h"
#import "StringValidation.h"


@implementation ResultsViewInfo

@synthesize simResultsController;
@synthesize viewTitle;

-(id)initWithSimResultsController:(SimResultsController*)theSimResultsController
	andViewTitle:(NSString*)theViewTitle
{
	self = [super init];
	if(self)
	{
		
		assert([StringValidation nonEmptyString:theViewTitle]);
		self.viewTitle = theViewTitle;
		self.simResultsController = theSimResultsController;
		
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
	[simResultsController release];
	[viewTitle release];
}

@end
