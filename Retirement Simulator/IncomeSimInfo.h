//
//  IncomeSimInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IncomeInput;
@class InputValDigestSummation;
@class SimParams;

@interface IncomeSimInfo : NSObject {
    @private
		IncomeInput *income;
		InputValDigestSummation *digestSum;
		SimParams *simParams;
}

@property(nonatomic,retain) IncomeInput *income;
@property(nonatomic,retain) InputValDigestSummation *digestSum;
@property(nonatomic,retain) SimParams *simParams;

-(id)initWithIncome:(IncomeInput*)theIncome andSimParams:(SimParams*)theSimParams;

@end
