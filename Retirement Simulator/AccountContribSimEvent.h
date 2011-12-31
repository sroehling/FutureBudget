//
//  SavingsContributionSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"

@class AccountSimInfo;

@interface AccountContribSimEvent : SimEvent {
    @private
		AccountSimInfo *acctSimInfo;
		double contributionAmount;
}

@property(nonatomic,retain) AccountSimInfo *acctSimInfo;
@property double contributionAmount;

@end
