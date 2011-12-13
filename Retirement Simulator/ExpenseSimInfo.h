//
//  ExpenseSimInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ExpenseInput;
@class InputValDigestSummation;
@class SimParams;

@interface ExpenseSimInfo : NSObject {
    @private
		ExpenseInput *expense;
		InputValDigestSummation *digestSum;
		SimParams *simParams;
}

@property(nonatomic,retain) ExpenseInput *expense;
@property(nonatomic,retain) InputValDigestSummation *digestSum;
@property(nonatomic,retain) SimParams *simParams;

-(id)initWithExpense:(ExpenseInput*)theExpense andSimParams:(SimParams*)theSimParams;

@end
