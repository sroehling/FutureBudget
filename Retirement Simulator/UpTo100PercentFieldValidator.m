//
//  UpTo100PercentFieldValidator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UpTo100PercentFieldValidator.h"
#import "LocalizationHelper.h"


@implementation UpTo100PercentFieldValidator

- (id)init
{
	self = [super initWithValidationMsg:LOCALIZED_STR(@"NUMBER_VALIDATION_UPTO100_PERCENT_MSG")];
	return self;
}

-(BOOL)validateNumber:(NSNumber *)theNumber
{
	assert(theNumber != nil);
	if(([theNumber doubleValue] >= 0.0) && ([theNumber doubleValue] <= 100.0))
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}



@end
