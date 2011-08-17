//
//  IncomeSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"

@class IncomeInput;

@interface IncomeSimEvent : SimEvent {
    @private
		IncomeInput *income;
		double incomeAmount;
}

@property(nonatomic,retain) IncomeInput *income;
@property double incomeAmount;

@end
