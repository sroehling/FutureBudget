//
//  FinishedAddingTaxBracketEntryListener.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FinishedAddingTaxBracketEntryListener.h"

#import "TaxBracket.h"
#import "TaxBracketEntry.h"

@implementation FinishedAddingTaxBracketEntryListener

@synthesize taxBracket;

-(id)initWithTaxBracket:(TaxBracket*)theTaxBracket
{
	self = [super init];
	if(self)
	{
		assert(theTaxBracket != nil);
		self.taxBracket = theTaxBracket;
	}
	return self;
}

-(void)objectFinshedBeingAdded:(NSManagedObject*)addedObject
{
	assert(self.taxBracket != nil);
	assert(addedObject != nil);
	// TODO - Do a full type checking on the addedObject (here and in other similar methods)
	TaxBracketEntry *bracketEntry = (TaxBracketEntry*)addedObject;
	assert(bracketEntry != nil);
	[self.taxBracket addTaxBracketEntriesObject:bracketEntry];
}


- (void)dealloc
{
	[super dealloc];
	[taxBracket release];
}

@end
