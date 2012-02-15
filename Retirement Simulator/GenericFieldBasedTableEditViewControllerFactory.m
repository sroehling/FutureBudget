//
//  GenericFieldBasedTableEditViewControllerFactory.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GenericFieldBasedTableEditViewControllerFactory.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "FormContext.h"

@implementation GenericFieldBasedTableEditViewControllerFactory

@synthesize formInfoCreator;


-(id)initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator
{
	self = [super init];
	if(self)
	{
		assert(theFormInfoCreator != nil);
		self.formInfoCreator = theFormInfoCreator;
	}
	return self;
}

-(id)init
{
	assert(0); // must call init with FormInfoCreator
	return nil;
}

-(UIViewController*)createTableView:(FormContext*)parentContext
{
	UIViewController *controller = [[[GenericFieldBasedTableEditViewController alloc]
	    initWithFormInfoCreator:self.formInfoCreator andDataModelController:parentContext.dataModelController] autorelease];
	return controller;
}

-(void)dealloc
{
	[formInfoCreator release];
	[super dealloc];
}


@end
