//
//  SharedAppValues.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SharedAppValues.h"
#import "NeverEndDate.h"


NSString * const SHARED_APP_VALUES_ENTITY_NAME = @"SharedAppValues";
NSString * const SHARED_APP_VALUES_CURRENT_INPUT_SCENARIO_KEY = @"currentInputScenario";

@implementation SharedAppValues
@dynamic sharedNeverEndDate;
@dynamic defaultScenario;
@dynamic currentInputScenario;
@dynamic repeatOnceFreq;

static SharedAppValues *theSharedAppVals;  


+(SharedAppValues*)singleton
{  
	assert(theSharedAppVals != nil);
	return theSharedAppVals;
}

+(void)initSingleton:(SharedAppValues*)theAppVals
{
	assert(theSharedAppVals == nil);
	assert(theAppVals != nil);
	[theAppVals retain];
	theSharedAppVals = theAppVals;
}

@end
