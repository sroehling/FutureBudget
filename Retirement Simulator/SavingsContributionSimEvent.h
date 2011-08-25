//
//  SavingsContributionSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"

@class SavingsWorkingBalance;

@interface SavingsContributionSimEvent : SimEvent {
    @private
		SavingsWorkingBalance *savingsBalance;
		double contributionAmount;
		bool contributionIsTaxable;
}

@property(nonatomic,retain) SavingsWorkingBalance *savingsBalance;
@property double contributionAmount;
@property bool contributionIsTaxable;

@end
