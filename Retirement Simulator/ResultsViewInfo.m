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

@synthesize viewTitle;

-(id)initWithViewTitle:(NSString*)theViewTitle
{
	self = [super init];
	if(self)
	{
		assert([StringValidation nonEmptyString:theViewTitle]);
		self.viewTitle = theViewTitle;		
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
	[viewTitle release];
	[super dealloc];
}

@end
