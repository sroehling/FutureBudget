//
//  VariableDateRuntimeInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableDateRuntimeInfo.h"

#import "CashFlowInput.h"
#import "VariableValueRuntimeInfo.h"

@implementation VariableDateRuntimeInfo

+ (VariableDateRuntimeInfo*)createForCashFlowStartDate:(CashFlowInput*)cashFlow
{
	return [[[VariableDateRuntimeInfo alloc] init] autorelease];

}

+ (VariableDateRuntimeInfo*)createForCashFlowEndDate:(CashFlowInput*)cashFlow
{
	return [[[VariableDateRuntimeInfo alloc] init] autorelease];
}

+ (VariableDateRuntimeInfo*)createForDateSensitiveValue:(VariableValueRuntimeInfo*)valRuntimeInfo
{
	return [[[VariableDateRuntimeInfo alloc] init] autorelease];

}

@end
