//
//  NumberFieldValidator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NumberFieldValidator.h"


@implementation NumberFieldValidator

@synthesize validationFailedMsg;

- (id)initWithValidationMsg:(NSString*)validationMsg
{
	self = [super init];
	if(self)
	{
		assert(validationMsg != nil);
		self.validationFailedMsg = validationMsg;
	}
	return self;
}

-(id)init
{
	assert(0); // must init with validation msg
}


-(void)dealloc
{
	[validationFailedMsg release];
	[super dealloc];
}


-(BOOL)validateNumber:(NSNumber *)theNumber
{
	assert(0); // must be overidden
	return FALSE;
}

@end
