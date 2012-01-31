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

- (UIViewController*)createTableView
{
	UIViewController *controller = [[[GenericFieldBasedTableViewController alloc]
	    initWithFormInfoCreator:self.formInfoCreator] autorelease];
	return controller;
}

-(void)dealloc
{
	[super dealloc];
	[formInfoCreator release];
}



@end
