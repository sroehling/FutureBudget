//
//  PositiveAmountValidator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PositiveAmountValidator.h"
#import "LocalizationHelper.h"


@implementation PositiveAmountValidator

- (id)init
{
	self = [super initWithValidationMsg:LOCALIZED_STR(@"NUMBER_VALIDATION_POSITIVE_AMOUNT_MSG")];
	return self;
}

-(BOOL)validateNumber:(NSNumber *)theNumber
{
	assert(theNumber != nil);
	if([theNumber doubleValue] >= 0.0)
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}


@end
