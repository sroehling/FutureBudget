//
//  DefaultInflationRate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DefaultInflationRate.h"
#import "LocalizationHelper.h"

NSString * const DEFAULT_INFLATION_RATE_ENTITY_NAME 
		= @"DefaultInflationRate";

@implementation DefaultInflationRate

@dynamic sharedAppValsDefaultInflationRate;

-(NSString*)label
{
	return LOCALIZED_STR(@"DEFAULT_INFLATION_RATE_LABEL");
}

- (BOOL)supportsDeletion
{
	return FALSE;
}

- (BOOL)nameIsStaticLabel
{
	return TRUE;
}


@end
