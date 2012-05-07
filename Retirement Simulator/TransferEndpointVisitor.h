//
//  TransferEndpointVisitor.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TransferEndpointCash;
@class TransferEndpointAcct;

@protocol TransferEndpointVisitor <NSObject>

-(void)visitCashEndpoint:(TransferEndpointCash*)endpoint;
-(void)visitAcctEndpoint:(TransferEndpointAcct*)endpoint;

@end
