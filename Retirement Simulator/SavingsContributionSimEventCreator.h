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

@interface SavingsContributionSimEventCreator : NSObject <SimEventCreator> {
    @private
        SavingsAccount *savingsAcct;
        EventRepeater *eventRepeater;
		VariableRateCalculator *varRateCalc;
		id<ValueAsOfCalculator> varAmountCalc;
		NSDate *startAmountGrowthDate;
}

- (id)initWithSavingsAcct:(SavingsAccount*)theSavingsAcct;

@property(nonatomic,retain) SavingsAccount *savingsAcct;
@property(nonatomic,retain) EventRepeater *eventRepeater;
@property(nonatomic,retain) VariableRateCalculator *varRateCalc;
@property(nonatomic,retain) id<ValueAsOfCalculator> varAmountCalc;
@property(nonatomic,retain) NSDate *startAmountGrowthDate;

@end
