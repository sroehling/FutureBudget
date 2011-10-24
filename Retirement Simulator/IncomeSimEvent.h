//
//  IncomeSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"

@class IncomeSimInfo;

@interface IncomeSimEvent : SimEvent {
    @private
		IncomeSimInfo *incomeInfo;
		double incomeAmount;
}

@property(nonatomic,retain) IncomeSimInfo *incomeInfo;
@property double incomeAmount;

@end
