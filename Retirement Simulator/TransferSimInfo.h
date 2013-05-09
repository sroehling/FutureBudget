//
//  TransferSimInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WorkingBalance.h"

@class TransferInput;
@class SimParams;
@class InputValDigestSummation;

@interface TransferSimInfo : NSObject {
	@private
		TransferInput *transferInput;
		SimParams *simParams;
		InputValDigestSummation *digestSum;
		id<WorkingBalance> fromWorkingBal;
		id<WorkingBalance> toWorkingBal;
}


@property(nonatomic,retain) SimParams *simParams;
@property(nonatomic,retain) TransferInput *transferInput;
@property(nonatomic,retain) InputValDigestSummation *digestSum;
@property(nonatomic,retain) id<WorkingBalance> fromWorkingBal;
@property(nonatomic,retain) id<WorkingBalance> toWorkingBal;

-(id)initWithTransferInput:(TransferInput*)theTransferInput 
		andSimParams:(SimParams*)theSimParams;

@end
