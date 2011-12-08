//
//  EndOfYearInputResults.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EndOfYearInputResults.h"
#import "Input.h"


@implementation EndOfYearInputResults

@synthesize inputResultMap;


-(id)init
{
	self = [super init];
	if(self)
	{
		self.inputResultMap = [[[NSMutableDictionary alloc] init] autorelease];
	}
	return self;
}

-(void)setResultForInput:(Input*)input andValue:(double)val
{
	assert(input != nil);
	NSNumber *valObj = [NSNumber numberWithDouble:val];
	[self.inputResultMap setObject:valObj forKey:[input objectID]];
}

-(double)getResultForInput:(Input*)input
{
	assert(input != nil);
	NSNumber *valObj = [self.inputResultMap objectForKey:[input objectID]];
	assert(valObj != nil);
	return [valObj doubleValue];
}

-(void)dealloc
{
	[super dealloc];
	[inputResultMap release];
}

@end
