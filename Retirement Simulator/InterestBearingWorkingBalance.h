//
//  SavingsWorkingBalance.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WorkingBalanceBaseImpl.h"

@class Account;
@class DateSensitiveValue;
@class VariableRateCalculator;
@class InputValDigestSummation;
@class SimParams;

@interface InterestBearingWorkingBalance : WorkingBalanceBaseImpl {
    @private
		VariableRateCalculator *interestRateCalc;
		InputValDigestSummation *accruedInterest;
		NSString *workingBalanceName;
}

@property(nonatomic,retain )VariableRateCalculator *interestRateCalc;
@property(nonatomic,retain ) NSString *workingBalanceName;
@property(nonatomic,retain) InputValDigestSummation *accruedInterest;

- (id) initWithStartingBalance:(double)theStartBalance 
	andInterestRateCalc:(VariableRateCalculator*)theInterestRateCalc 
	andWorkingBalanceName:(NSString *)wbName 
	andWithdrawPriority:(double)theWithdrawPriority;
	
	
- (id) initWithStartingBalance:(double)theStartBalance
	andInterestRate:(DateSensitiveValue*)theInterestRate
	andWorkingBalanceName:(NSString*)wbName
	andStartDate:(NSDate*)theStartDate
	andWithdrawPriority:(double)theWithdrawPriority;	

- (id) initWithAcct:(Account*)theAcct 
	andSimParams:(SimParams*)simParams;

@end
