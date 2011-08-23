//
//  SavingsContributionSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"
#import "ValueAsOfCalculator.h"
#import "SavingsAccount.h"

@class EventRepeater;
@class VariableRateCalculator;
@class SavingsWorkingBalance;

@interface SavingsContributionSimEventCreator : NSObject <SimEventCreator> {
    @private
        SavingsWorkingBalance *savingsWorkingBalance;
		SavingsAccount *savingsAcct;
        EventRepeater *eventRepeater;
		VariableRateCalculator *varRateCalc;
		id<ValueAsOfCalculator> varAmountCalc;
}

- (id)initWithSavingsWorkingBalance:(SavingsWorkingBalance*)theWorkingBalance
	andSavingsAcct:(SavingsAccount*)theSavingsAcct;

@property(nonatomic,retain) SavingsWorkingBalance *savingsWorkingBalance;
@property(nonatomic,retain) SavingsAccount *savingsAcct;
@property(nonatomic,retain) EventRepeater *eventRepeater;
@property(nonatomic,retain) VariableRateCalculator *varRateCalc;
@property(nonatomic,retain) id<ValueAsOfCalculator> varAmountCalc;

@end
