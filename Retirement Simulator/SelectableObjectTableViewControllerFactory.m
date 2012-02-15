//
//  SelectableObjectTableViewControllerFactory.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectableObjectTableViewControllerFactory.h"

#import "SelectableObjectTableEditViewController.h"
#import "FormContext.h"


@implementation SelectableObjectTableViewControllerFactory

@synthesize formInfoCreator;
@synthesize assignedField;



-(id)initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator
	andAssignedField:(FieldInfo*)theFieldInfo
{
	self = [super init];
	if(self)
	{
		assert(theFieldInfo != nil);
		self.assignedField = theFieldInfo;
		
		assert(theFormInfoCreator != nil);
		self.formInfoCreator = theFormInfoCreator;
	}
	return self;
}

-(id)init
{
	assert(0); // must call init with FormInfoCreator and FieldInfo
	return nil;
}


- (UIViewController*)createTableView:(FormContext*)parentContext
{
	SelectableObjectTableEditViewController *theController = [[[SelectableObjectTableEditViewController alloc]
		initWithFormInfoCreator:self.formInfoCreator
		 andAssignedField:self.assignedField andDataModelController:parentContext.dataModelController] autorelease];
	return theController;
}

-(void)dealloc
{
	[formInfoCreator release];
	[assignedField release];
	[super dealloc];
}

@end
