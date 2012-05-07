//
//  TransferSimInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TransferInput;
@class SimParams;
@class InputValDigestSummation;
@class WorkingBalance;

@interface TransferSimInfo : NSObject {
	@private
		TransferInput *transferInput;
		SimParams *simParams;
		InputValDigestSummation *digestSum;
		WorkingBalance *fromWorkingBal;
		WorkingBalance *toWorkingBal;
}


@property(nonatomic,retain) SimParams *simParams;
@property(nonatomic,retain) TransferInput *transferInput;
@property(nonatomic,retain) InputValDigestSummation *digestSum;
@property(nonatomic,retain) WorkingBalance *fromWorkingBal;
@property(nonatomic,retain) WorkingBalance *toWorkingBal;

-(id)initWithTransferInput:(TransferInput*)theTransferInput 
		andSimParams:(SimParams*)theSimParams;

@end
