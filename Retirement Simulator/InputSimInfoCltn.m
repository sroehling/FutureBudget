//
//  InputSimInfoCltn.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputSimInfoCltn.h"
#import "Input.h"


@implementation InputSimInfoCltn

@synthesize inputSimInfoMap;
@synthesize inputsSimulated;

-(id)init
{
	self = [super init];
	if(self)
	{
		self.inputSimInfoMap = [[[NSMutableDictionary alloc] init] autorelease];
		self.inputsSimulated = [[[NSMutableSet alloc] init] autorelease];
	}
	return self;
}


-(id)findSimInfo:(Input*)theInput
{
	return [self.inputSimInfoMap objectForKey:[theInput objectID]];
}

-(id)getSimInfo:(Input*)theInput
{

	id theSimInfo = [self findSimInfo:theInput];
	assert(theSimInfo != nil);
	return theSimInfo;
}

-(void)addSimInfo:(Input*)theInput withSimInfo:(id)simInfo
{
	assert(theInput != nil);
	assert(simInfo != nil);
	assert([self findSimInfo:theInput] == nil); // duplicates not allowed
	
	[self.inputsSimulated addObject:theInput];
	
	// TODO - Need to definitively verify insertion and retrieval of 
	// objects into the dictionary. An ID stored with the input is
	// likely needed.
	[self.inputSimInfoMap setObject:simInfo forKey:[theInput objectID]];
}

-(NSArray*)simInfos
{
	return [self.inputSimInfoMap allValues];
}

-(void)dealloc
{
	[inputSimInfoMap release];
	[inputsSimulated release];
	[super dealloc];
}

@end
