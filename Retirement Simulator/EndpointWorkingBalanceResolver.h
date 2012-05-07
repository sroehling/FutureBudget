//
//  EndpointWorkingBalanceResolver.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TransferEndpointVisitor.h"

@class SimParams;
@class WorkingBalance;
@class TransferEndpoint;

@interface EndpointWorkingBalanceResolver : NSObject <TransferEndpointVisitor> {
	@private
		SimParams *simParams;
		WorkingBalance *resolvedBalance;
}

@property(nonatomic,retain) SimParams *simParams;
@property(nonatomic,retain) WorkingBalance *resolvedBalance;

-(id)initWithSimParams:(SimParams*)theSimParams;
-(WorkingBalance*)resolveWorkingBalance:(TransferEndpoint*)endpoint;

@end
