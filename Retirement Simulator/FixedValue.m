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

- (NSString*) valueDescription
{
    return @"Fixed value";
}

- (NSString*) inlineDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
	NSString *displayValDesc  =[[NumberHelper theHelper] displayStrFromStoredVal:self.value andFormatter:valueRuntimeInfo.valueFormatter];
	
	return [NSString stringWithFormat:@"%@ %@ every year",valueRuntimeInfo.valueVerb,
			displayValDesc];
}

@end
