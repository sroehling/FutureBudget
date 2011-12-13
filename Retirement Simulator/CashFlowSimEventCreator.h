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
		NSDate *simStartDate;
}

- (id)initWithCashFlow:(CashFlowInput*)theCashFlow andSimStartDate:(NSDate*)simStart;

@property(nonatomic,assign) CashFlowInput *cashFlow;
@property(nonatomic,retain) VariableRateCalculator *varRateCalc;
@property(nonatomic,retain) id<ValueAsOfCalculator> varAmountCalc;
@property(nonatomic,retain) EventRepeater *eventRepeater;
@property(nonatomic,retain) NSDate *simStartDate;

- (SimEvent*) createCashFlowSimEvent:(double)cashFlowAmount andEventDate:(NSDate*)theDate;

@end
