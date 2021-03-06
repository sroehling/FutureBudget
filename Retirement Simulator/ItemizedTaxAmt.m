//
//  ItemizedTaxAmt.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxAmt.h"
#import "MultiScenarioInputValue.h"


@implementation ItemizedTaxAmt

@dynamic itemizedTaxAmts;
@dynamic multiScenarioApplicablePercent;
@dynamic isEnabled;

-(void)acceptVisitor:(id<ItemizedTaxAmtVisitor>)visitor
{
	assert(0); // must be overriden
}

-(BOOL)itemIsEnabledForScenario:(Scenario*)theScenario
{
	assert(0); // must be overridden
	return FALSE;
}

@end
