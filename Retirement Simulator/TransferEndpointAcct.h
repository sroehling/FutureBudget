//
//  TransferEndpointAcct.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TransferEndpoint.h"

@class Account;

extern NSString * const TRANSFER_ENDPOINT_ACCT_ENTITY_NAME;

@interface TransferEndpointAcct : TransferEndpoint

@property (nonatomic, retain) Account *account;


@end
