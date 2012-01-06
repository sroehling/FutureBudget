//
//  LimitedAccountWithdrawalsTableViewFactory.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LimitedAccountWithdrawalsTableViewFactory.h"
#import "SelectableObjectTableEditViewController.h"
#import "LimitedWithdrawalExpenseFormInfoCreator.h"
#import "MultipleSelectionTableViewController.h"
#import "Account.h"

@implementation LimitedAccountWithdrawalsTableViewFactory

@synthesize account;

-(id)initWithAccount:(Account*)theAccount
{
	self = [super init];
	if(self)
	{
		assert(theAccount != nil);
		self.account = theAccount;
	}
	return self;
}

-(id)init
{
	assert(0); // must init with Account
	return nil;
}

- (UIViewController*)createTableView
{	
	LimitedWithdrawalExpenseFormInfoCreator *formInfoCreator = 
		[[[LimitedWithdrawalExpenseFormInfoCreator alloc] initWithAccount:self.account] autorelease];
	
	MultipleSelectionTableViewController *theController = 
		[[[MultipleSelectionTableViewController alloc] 
			initWithFormInfoCreator:formInfoCreator] autorelease];
	return theController;

}

-(void)dealloc
{
	[super dealloc];
	[account release];
}


@end
