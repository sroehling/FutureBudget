//
//  AcctResultGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AcctResultGenerator.h"
#import "SimResults.h"

#import "Account.h"

@implementation AcctResultGenerator

@synthesize account;

-(id)initWithAccount:(Account*)theAccount
{
	self = [super init];
	if(self)
	{
		assert(theAccount != nil);
		self.account  = theAccount;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(void)dealloc
{
	[account release];
	[super dealloc];
}

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResults*)simResults
{
	assert(0); // must be overridden
	return nil;
}

-(NSString*)dataLabel
{
	assert(0); //must be overridden
	return nil;
}

-(NSString*)dataYearlyUnitLabel
{
	assert(0); //must be overridden
	return nil;
}


-(BOOL)resultsDefinedInSimResults:(SimResults*)simResults
{
	return [simResults.acctsSimulated containsObject:self.account];
}


@end
