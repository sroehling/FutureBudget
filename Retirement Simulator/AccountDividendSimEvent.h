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
		double dividendAmount;
}

@property(nonatomic,retain) AccountSimInfo *acctSimInfo;
@property double dividendAmount;

@end
