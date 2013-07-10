//
//  AccountSimInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;
@class AccountWorkingBalance;
@class SimParams;
@class InputValDigestSummation;

@interface AccountSimInfo : NSObject {
    @private
		Account *account;

		AccountWorkingBalance *acctBal;
				
		InputValDigestSummation *dividendPayments;
		
		// Portion of dividend which is not reinvested.
		// This is used for tallying up the overall cash flow.
		InputValDigestSummation *dividendPayouts;
		

		SimParams *simParams;
}

@property(nonatomic,retain) Account *account;
@property(nonatomic,retain) AccountWorkingBalance *acctBal;
@property(nonatomic,retain) InputValDigestSummation *dividendPayments;
@property(nonatomic,retain) InputValDigestSummation *dividendPayouts;

@property(nonatomic,retain) SimParams *simParams;

-(id)initWithAcct:(Account*)theAcct andSimParams:(SimParams *)theSimParams;

-(void)addContribution:(double)contributionAmount onDate:(NSDate*)contributionDate;

@end
