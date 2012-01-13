//
//  MultipleSelectionTableViewControllerFactory.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MultipleSelectionTableViewControllerFactory.h"

#import "MultipleSelectionTableViewController.h"

@implementation MultipleSelectionTableViewControllerFactory

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
	UIViewController *controller = [[[MultipleSelectionTableViewController alloc]
	    initWithFormInfoCreator:self.formInfoCreator] autorelease];
	return controller;
}

-(void)dealloc
{
	[super dealloc];
	[formInfoCreator release];
}


@end
