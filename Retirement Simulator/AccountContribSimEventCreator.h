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
@class AccountSimInfo;

@interface AccountContribSimEventCreator : NSObject <SimEventCreator> {
    @private
		AccountSimInfo *acctSimInfo;
		
        EventRepeater *eventRepeater;
		VariableRateCalculator *varRateCalc;
		id<ValueAsOfCalculator> varAmountCalc;
}

- (id)initWithAcctSimInfo:(AccountSimInfo*)theAcctSimInfo;
	
@property(nonatomic,retain) AccountSimInfo *acctSimInfo;

@property(nonatomic,retain) EventRepeater *eventRepeater;
@property(nonatomic,retain) VariableRateCalculator *varRateCalc;
@property(nonatomic,retain) id<ValueAsOfCalculator> varAmountCalc;


@end
