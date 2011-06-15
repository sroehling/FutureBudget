//
//  DateSensitiveValue.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValue.h"
#import "VariableValueRuntimeInfo.h"

@implementation DateSensitiveValue

- (NSString*) valueDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
    assert(0); // must be overridden
	return nil;
}

- (NSString*) inlineDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
	assert(0); // must be overridden
	return nil;
}

- (NSString*) standaloneDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
	assert(0); // must be overridden
	return nil;
}

@end
