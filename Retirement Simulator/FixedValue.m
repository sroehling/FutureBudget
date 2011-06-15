//
//  FixedValue.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FixedValue.h"
#import "VariableValueRuntimeInfo.h"
#import "NumberHelper.h"


@implementation FixedValue
@dynamic value;

- (NSString*) valueDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
    return [[NumberHelper theHelper] displayStrFromStoredVal:self.value andFormatter:valueRuntimeInfo.valueFormatter];
}

- (NSString*) inlineDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
	NSString *displayValDesc  =[[NumberHelper theHelper] displayStrFromStoredVal:self.value andFormatter:valueRuntimeInfo.valueFormatter];
	
	return [NSString stringWithFormat:@"%@ every year",displayValDesc];
}

- (NSString*) standaloneDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
	return [self inlineDescription:valueRuntimeInfo];
}



@end
