//
//  ItemizedAccountTaxAmtCreatorBase.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemizedAccountTaxAmtCreatorBase.h"

#import "Account.h"
#import "StringValidation.h"

@implementation ItemizedAccountTaxAmtCreatorBase

@synthesize account;
@synthesize label;

- (id)initWithAcct:(Account*)theAccount andLabel:(NSString*)theLabel
{
	self = [super init];
	if(self)
	{
		assert(theAccount != nil);
		self.account = theAccount;

		assert([StringValidation nonEmptyString:theLabel]);
		self.label = theLabel;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}


-(NSString*)itemLabel
{
	return self.label;
}

- (ItemizedTaxAmt*)createItemizedTaxAmt
{
	assert(0); // must be overridden
	return nil;
}


-(void)dealloc
{
	[super dealloc];
	[account release];
	[label release];
}

@end
