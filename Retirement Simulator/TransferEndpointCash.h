//
//  TransferEndpointCash.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TransferEndpoint.h"

@class Cash;
@class SharedAppValues;

extern NSString * const TRANSFER_ENDPOINT_CASH_ENTITY_NAME;

@interface TransferEndpointCash : TransferEndpoint

@property (nonatomic, retain) Cash *cash;
@property (nonatomic, retain) SharedAppValues *sharedAppValsCashTransferEndpoint;

@end
