//
//  FinishedAddingItemizedTaxAmtListener.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FinishedAddingItemizedTaxAmtListener.h"
#import "ItemizedTaxAmt.h"


@implementation FinishedAddingItemizedTaxAmtListener

@synthesize itemizedTaxAmts;

-(id)initWithItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts
{
	self = [super init];
	if(self)
	{
		assert(theItemizedTaxAmts != nil);
		self.itemizedTaxAmts = theItemizedTaxAmts;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(void)objectFinshedBeingAdded:(NSManagedObject*)addedObject
{
	assert(self.itemizedTaxAmts != nil);
	assert(addedObject != nil);
	assert([addedObject isKindOfClass:[ItemizedTaxAmt class]]);
	// TODO - Do a full type checking on the addedObject (here and in other similar methods)
	ItemizedTaxAmt *theAmt = (ItemizedTaxAmt*)addedObject;
	assert(theAmt != nil);
	[self.itemizedTaxAmts addItemizedAmtsObject:theAmt];
}


- (void)dealloc
{
	[super dealloc];
	[itemizedTaxAmts release];
}

@end
