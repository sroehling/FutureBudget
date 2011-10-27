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
}

@property(nonatomic,retain) ExpenseInput *expense;
@property(nonatomic,retain) InputValDigestSummation *digestSum;

-(id)initWithExpense:(ExpenseInput*)theExpense andSimParams:(SimParams*)theSimParams;

@end
