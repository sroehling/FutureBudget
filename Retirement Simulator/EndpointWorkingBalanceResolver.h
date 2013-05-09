//
//  EndpointWorkingBalanceResolver.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TransferEndpointVisitor.h"
#import "WorkingBalance.h"

@class SimParams;
@class TransferEndpoint;

@interface EndpointWorkingBalanceResolver : NSObject <TransferEndpointVisitor> {
	@private
		SimParams *simParams;
		id<WorkingBalance> resolvedBalance;
}

@property(nonatomic,retain) SimParams *simParams;
@property(nonatomic,retain) id<WorkingBalance> resolvedBalance;

-(id)initWithSimParams:(SimParams*)theSimParams;
-(id<WorkingBalance>)resolveWorkingBalance:(TransferEndpoint*)endpoint;

@end
