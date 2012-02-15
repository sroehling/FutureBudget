//
//  GenericFieldBasedTableViewControllerFactory.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GenericFieldBasedTableViewControllerFactory.h"
#import "GenericFieldBasedTableViewController.h"
#import "FormInfoCreator.h"
#import "FormContext.h"

@implementation GenericFieldBasedTableViewControllerFactory

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
	UIViewController *controller = [[[GenericFieldBasedTableViewController alloc]
	    initWithFormInfoCreator:self.formInfoCreator andDataModelController:parentContext.dataModelController ] autorelease];
	return controller;
}

-(void)dealloc
{
	[formInfoCreator release];
	[super dealloc];
}



@end
