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

-(id)init
{
	self = [super init];
	if(self)
	{
		self.inputSimInfoMap = [[[NSMutableDictionary alloc] init] autorelease];
	}
	return self;
}

-(NSString*)inputKey:(Input*)theInput
{
	assert(theInput != nil);
	return [[[theInput objectID] URIRepresentation] absoluteString];
}

-(id)findSimInfo:(Input*)theInput
{
	return [self.inputSimInfoMap objectForKey:[self inputKey:theInput]];
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
		
	[self.inputSimInfoMap setValue:simInfo forKey:[self inputKey:theInput]];
}

-(void)dealloc
{
	[super dealloc];
	[inputSimInfoMap release];
}

@end
