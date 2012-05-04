//
//  TransferEndpointAcct.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransferEndpointAcct.h"
#import "Account.h"

NSString * const TRANSFER_ENDPOINT_ACCT_ENTITY_NAME = @"TransferEndpointAcct";

@implementation TransferEndpointAcct

@dynamic account;

-(NSString*)endpointLabel
{
	return self.account.name;
}

@end
