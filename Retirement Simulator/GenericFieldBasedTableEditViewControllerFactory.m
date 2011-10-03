//
//  GenericFieldBasedTableEditViewControllerFactory.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GenericFieldBasedTableEditViewControllerFactory.h"
#import "GenericFieldBasedTableEditViewController.h"

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

- (UIViewController*)createTableView
{
	UIViewController *controller = [[[GenericFieldBasedTableEditViewController alloc]
	    initWithFormInfoCreator:self.formInfoCreator] autorelease];
	return controller;
}

-(void)dealloc
{
	[super dealloc];
	[formInfoCreator release];
}


@end
