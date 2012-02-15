//
//  FormContext.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FormContext.h"


@implementation FormContext


@synthesize dataModelController;
@synthesize parentController;


-(id)initWithParentController:(UIViewController*)theParentController
	andDataModelController:(DataModelController*)theDataModelController
{
	self = [super init];
	if(self)
	{
		assert(theParentController !=nil);
		assert(theDataModelController != nil);

		self.parentController = theParentController;
		self.dataModelController = theDataModelController;

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
	[dataModelController release];
	[super dealloc];
}

@end
