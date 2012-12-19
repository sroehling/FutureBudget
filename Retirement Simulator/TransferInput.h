//
//  TransferInput.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CashFlowInput.h"

@class TransferEndpoint;

extern NSString * const TRANSFER_INPUT_ENTITY_NAME;
extern NSString * const TRANSFER_INPUT_FROM_ENDPOINT_KEY;
extern NSString * const TRANSFER_INPUT_TO_ENDPOINT_KEY;
extern NSString * const TRANSFER_INPUT_DEFAULT_ICON_NAME;

@interface TransferInput : CashFlowInput

@property (nonatomic, retain) TransferEndpoint *fromEndpoint;
@property (nonatomic, retain) TransferEndpoint *toEndpoint;

@end
