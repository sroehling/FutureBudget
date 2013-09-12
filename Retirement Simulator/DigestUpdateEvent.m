//
//  DigestUpdateEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DigestUpdateEvent.h"
#import "DateHelper.h"
#import "FiscalYearDigest.h"


@implementation DigestUpdateEvent


- (void)doSimEvent:(FiscalYearDigest*)digest
{
	[digest advanceToNextYear];
}

@end
