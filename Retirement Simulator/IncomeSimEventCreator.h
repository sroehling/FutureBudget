//
//  IncomeSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CashFlowSimEventCreator.h"

@class IncomeInput;

@interface IncomeSimEventCreator : CashFlowSimEventCreator {
    @private
		IncomeInput *income;
}

@property(nonatomic,retain) IncomeInput *income;

- (id) initWithIncome:(IncomeInput*)theIncome;


@end
