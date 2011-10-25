//
//  SavingsContributionSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"

@class InterestBearingWorkingBalance;

@interface SavingsContributionSimEvent : SimEvent {
    @private
		InterestBearingWorkingBalance *savingsBalance;
		double contributionAmount;
}

@property(nonatomic,retain) InterestBearingWorkingBalance *savingsBalance;
@property double contributionAmount;

@end
