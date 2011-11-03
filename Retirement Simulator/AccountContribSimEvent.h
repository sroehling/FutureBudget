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

@interface AccountContribSimEvent : SimEvent {
    @private
		InterestBearingWorkingBalance *acctBalance;
		double contributionAmount;
}

@property(nonatomic,retain) InterestBearingWorkingBalance *acctBalance;
@property double contributionAmount;

@end
