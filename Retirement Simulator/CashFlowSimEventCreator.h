//
//  ExpenseInputSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"
#import "ValueAsOfCalculator.h"

@class CashFlowInput;
@class EventRepeater;
@class VariableRateCalculator;

@interface CashFlowSimEventCreator : NSObject <SimEventCreator> {
    @private
        CashFlowInput *cashFlow;
        EventRepeater *eventRepeater;
		VariableRateCalculator *varRateCalc;
		id<ValueAsOfCalculator> varAmountCalc;
		NSDate *startAmountGrowthDate;
}

- (id)initWithCashFlow:(CashFlowInput*)theCashFlow;

@property(nonatomic,assign) CashFlowInput *cashFlow;
@property(nonatomic,retain) VariableRateCalculator *varRateCalc;
@property(nonatomic,retain) id<ValueAsOfCalculator> varAmountCalc;
@property(nonatomic,retain) NSDate *startAmountGrowthDate;
@property(nonatomic,retain) EventRepeater *eventRepeater;

- (SimEvent*) createCashFlowSimEvent:(double)cashFlowAmount andEventDate:(NSDate*)theDate;

@end
