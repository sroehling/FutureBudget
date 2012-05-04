//
//  TransferEndpoint.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransferEndpoint.h"
#import "TransferInput.h"


@implementation TransferEndpoint

@synthesize isSelectedForSelectableObjectTableView;

@dynamic transferFromEndpoint;
@dynamic transferToEndpoint;

-(NSString*)endpointLabel
{
	assert(0); // must be overridden
	return nil;
}

@end
