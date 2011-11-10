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

NSString * const FIXED_VALUE_ENTITY_NAME = @"FixedValue";
NSString * const FIXED_VALUE_VALUE_KEY = @"value";

@implementation FixedValue
@dynamic value;

// TODO - Need more handling for cascading deletes involving this object (and other InputValue descendents). 
// As it is implemented now, deleting a reference to this
// object may result in an orphan.
@dynamic sharedAppValuesDeficitInterestRate;



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
