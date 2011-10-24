//
//  IncomeSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CashFlowSimEventCreator.h"

@class IncomeSimInfo;

@interface IncomeSimEventCreator : CashFlowSimEventCreator {
    @private
		IncomeSimInfo *incomeInfo;
}

@property(nonatomic,retain) IncomeSimInfo *incomeInfo;

- (id)initWithIncomeSimInfo:(IncomeSimInfo*)theIncomeSimInfo;

@end
