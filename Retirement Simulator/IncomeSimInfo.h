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
}

@property(nonatomic,retain) IncomeInput *income;
@property(nonatomic,retain) InputValDigestSummation *digestSum;

-(id)initWithIncome:(IncomeInput*)theIncome andSimParams:(SimParams*)theSimParams;

@end
