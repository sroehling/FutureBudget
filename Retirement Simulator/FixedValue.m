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
#import "DateSensitiveValueVisitor.h"


@implementation FixedValue
@dynamic value;

- (NSString*) valueDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
    return [[NumberHelper theHelper] displayStrFromStoredVal:self.value andFormatter:valueRuntimeInfo.valueFormatter];
}

- (NSString*) valueSubtitle:(VariableValueRuntimeInfo *)valueRuntimeInfo
{
	return @"";
}


- (NSString*) inlineDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
	NSString *displayValDesc  =[[NumberHelper theHelper] displayStrFromStoredVal:self.value andFormatter:valueRuntimeInfo.valueFormatter];
	
	NSString *actionVerb = @"";
	if([valueRuntimeInfo.valueVerb length] >0)
	{
		actionVerb = [NSString stringWithFormat:@"%@ ",
					valueRuntimeInfo.valueVerb];
	}
	
	return [NSString stringWithFormat:@"%@%@%@",
			actionVerb,
			displayValDesc,[valueRuntimeInfo inlinePeriodDesc]];
}

- (NSString*) standaloneDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
	return [self inlineDescription:valueRuntimeInfo];
}


-(void)acceptDateSensitiveValVisitor:(id<DateSensitiveValueVisitor>)dsvVisitor
{
	[super acceptDateSensitiveValVisitor:dsvVisitor];
	[dsvVisitor visitFixedValue:self]; 
}


@end
