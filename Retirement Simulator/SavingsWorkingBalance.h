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
@class VariableRateCalculator;

@interface SavingsWorkingBalance : WorkingBalance {
    @private
		SavingsAccount *savingsAcct;
		VariableRateCalculator *interestRateCalc;
}

@property(nonatomic,retain) SavingsAccount *savingsAcct;
@property(nonatomic,retain )VariableRateCalculator *interestRateCalc;

- (id) initWithSavingsAcct:(SavingsAccount*)theSavingsAcct;

@end
