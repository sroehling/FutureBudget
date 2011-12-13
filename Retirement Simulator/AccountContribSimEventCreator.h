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

@class Account;
@class EventRepeater;
@class VariableRateCalculator;
@class InterestBearingWorkingBalance;

@interface AccountContribSimEventCreator : NSObject <SimEventCreator> {
    @private
        InterestBearingWorkingBalance *acctWorkingBalance;
		Account *account;
        EventRepeater *eventRepeater;
		VariableRateCalculator *varRateCalc;
		id<ValueAsOfCalculator> varAmountCalc;
		NSDate *simStartDate;
}

- (id)initWithWorkingBalance:(InterestBearingWorkingBalance*)theWorkingBalance
	andAcct:(Account*)theAcct andSimStartDate:(NSDate*)simStart;

@property(nonatomic,retain) InterestBearingWorkingBalance *acctWorkingBalance;
@property(nonatomic,retain) Account *account;
@property(nonatomic,retain) EventRepeater *eventRepeater;
@property(nonatomic,retain) VariableRateCalculator *varRateCalc;
@property(nonatomic,retain) id<ValueAsOfCalculator> varAmountCalc;
@property(nonatomic,retain) NSDate *simStartDate;

@end
