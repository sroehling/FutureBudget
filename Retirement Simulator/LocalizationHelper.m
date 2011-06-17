//
//  LocalizationHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocalizationHelper.h"


@implementation LocalizationHelper

+ (NSString*)localizeStringWithAssertionChecks:(NSString*)key
{
	assert(key != nil);
	assert([key length] > 0);
	NSString *theLocalizedString = NSLocalizedString(key,nil);
	assert(theLocalizedString != nil); // String must be found
	return theLocalizedString;
}

@end
