//
//  AccountSimInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;
@class InterestBearingWorkingBalance;
@class SimParams;
@class InputValDigestSummation;

@interface AccountSimInfo : NSObject {
    @private
		Account *account;

		InterestBearingWorkingBalance *acctBal;
		InputValDigestSummation *dividendPayments;

		SimParams *simParams;
}

@property(nonatomic,retain) Account *account;
@property(nonatomic,retain) InterestBearingWorkingBalance *acctBal;
@property(nonatomic,retain) InputValDigestSummation *dividendPayments;

@property(nonatomic,retain) SimParams *simParams;

-(id)initWithAcct:(Account*)theAcct andSimParams:(SimParams *)theSimParams;

@end
