//
//  StringLookupTable.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StringLookupTable.h"
#import "LocalizationHelper.h"


@implementation StringLookupTable

@synthesize lookupTable;


-(id)initWithStringLookupDictionary:(NSDictionary*)varStrings
{
	self = [super self];
	if(self)
	{
		self.lookupTable = varStrings;
	}
	return self;
}

-(id)init 
{
	assert(0); // must call init above
	return nil;
}

-(NSString*)stringVal:(NSString*)key
{
	assert(key != nil);
	assert([key length] > 0);
	NSString *val = [self.lookupTable objectForKey:key];
	assert(val != nil);
	return val;

}

-(NSString*)localizedStringVal:(NSString*)key
{
	return LOCALIZED_STR([self stringVal:key]);	
}

- (void) dealloc
{
	[super dealloc];
	[lookupTable release];
}

@end
