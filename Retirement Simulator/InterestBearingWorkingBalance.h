//
//  SavingsWorkingBalance.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WorkingBalance.h"

@class SavingsAccount;
@class DateSensitiveValue;
@class VariableRateCalculator;

@interface InterestBearingWorkingBalance : WorkingBalance {
    @private
		VariableRateCalculator *interestRateCalc;
		NSString *workingBalanceName;
		bool taxableWithdrawals;
		bool taxableInterest;
}

@property(nonatomic,retain )VariableRateCalculator *interestRateCalc;
@property(nonatomic,retain ) NSString *workingBalanceName;
@property bool taxableWithdrawals;
@property bool taxableInterest;

- (id) initWithStartingBalance:(double)theStartBalance
	andInterestRate:(DateSensitiveValue*)theInterestRate
	andWorkingBalanceName:(NSString*)wbName
	andStartDate:(NSDate*)theStartDate
	andTaxWithdrawals:(bool)doTaxWithdrawals
	andTaxInterest:(bool)doTaxInterest;
	
	
- (id) initWithStartingBalance:(double)theStartBalance 
	andInterestRateCalc:(VariableRateCalculator*)theInterestRateCalc 
	andWorkingBalanceName:(NSString *)wbName 
	andTaxWithdrawals:(bool)doTaxWithdrawals andTaxInterest:(bool)doTaxInterest;	

- (id) initWithSavingsAcct:(SavingsAccount*)theSavingsAcct;

@end
