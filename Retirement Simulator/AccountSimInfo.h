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

@interface AccountSimInfo : NSObject {
    @private
		Account *account;
		InterestBearingWorkingBalance *acctBal;
}

@property(nonatomic,retain) Account *account;
@property(nonatomic,retain) InterestBearingWorkingBalance *acctBal;

-(id)initWithAcct:(Account*)theAcct andSimParams:(SimParams *)simParams;

@end
