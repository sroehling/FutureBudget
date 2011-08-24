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

@interface SavingsWorkingBalance : WorkingBalance {
    @private
		VariableRateCalculator *interestRateCalc;
		NSString *workingBalanceName;
		bool taxableWithdrawals;
}

@property(nonatomic,retain )VariableRateCalculator *interestRateCalc;
@property(nonatomic,retain ) NSString *workingBalanceName;
@property bool taxableWithdrawals;

- (id) initWithStartingBalance:(double)theStartBalance
	andInterestRate:(DateSensitiveValue*)theInterestRate
	andWorkingBalanceName:(NSString*)wbName
	andStartDate:(NSDate*)theStartDate
	andTaxWithdrawals:(bool)doTaxWithdrawals;

- (id) initWithSavingsAcct:(SavingsAccount*)theSavingsAcct;

@end
