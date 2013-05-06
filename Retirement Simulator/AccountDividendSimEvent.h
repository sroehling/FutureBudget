//
//  AccountDividendSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/13.
//
//

#import "SimEvent.h"

@class AccountSimInfo;

@interface AccountDividendSimEvent : SimEvent
{
    @private
		AccountSimInfo *acctSimInfo;
}

@property(nonatomic,retain) AccountSimInfo *acctSimInfo;

@end
