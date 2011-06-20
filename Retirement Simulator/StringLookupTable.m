//
//  StringLookupTable.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StringLookupTable.h"


@implementation StringLookupTable

@synthesize lookupTable;


-(NSString*)stringVal:(NSString*)key
{
	assert(key != nil);
	assert([key length] > 0);
	return @"lookup";
}

-(NSString*)localizedStringVal:(NSString*)key
{
	assert(key != nil);
	assert([key length] > 0);	
	return @"lookup";
}

- (void) dealloc
{
	[super dealloc];
	[lookupTable release];
}

@end
