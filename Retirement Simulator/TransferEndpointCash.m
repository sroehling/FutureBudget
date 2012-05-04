//
//  TransferEndpointCash.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransferEndpointCash.h"
#import "Cash.h"
#import "LocalizationHelper.h"


NSString * const TRANSFER_ENDPOINT_CASH_ENTITY_NAME = @"TransferEndpointCash";

@implementation TransferEndpointCash

@dynamic cash;
@dynamic sharedAppValsCashTransferEndpoint;

-(NSString*)endpointLabel
{
	return LOCALIZED_STR(@"CASH_LABEL");
}


@end
