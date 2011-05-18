//
//  ExpenseInputSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"

@class CashFlowInput,EventRepeater;

@interface CashFlowSimEventCreator : NSObject <SimEventCreator> {
    @private
        CashFlowInput *cashFlow;
        EventRepeater *eventRepeater;
}

- (id)initWithCashFlow:(CashFlowInput*)theCashFlow;

@property(nonatomic,assign) CashFlowInput *cashFlow;

@end
