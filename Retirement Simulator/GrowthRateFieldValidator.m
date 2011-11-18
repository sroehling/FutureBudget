//
//  GrowthRateFieldValidator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GrowthRateFieldValidator.h"
#import "LocalizationHelper.h"



@implementation GrowthRateFieldValidator

- (id)init
{
	self = [super initWithValidationMsg:LOCALIZED_STR(@"NUMBER_VALIDATION_GROWTH_RATE_MSG")];
	return self;
}

-(BOOL)validateNumber:(NSNumber *)theNumber
{
	assert(theNumber != nil);
	if([theNumber doubleValue] > -100.0)
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

@end
