//
//  SavingsContributionSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"

@class SavingsAccount;

@interface SavingsContributionSimEvent : SimEvent {
    @private
		SavingsAccount *savingsAcct;
		double contributionAmount;
}

@property(nonatomic,retain) SavingsAccount *savingsAcct;
@property double contributionAmount;

@end
