//
//  LoanPaymentSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"

@interface LoanPaymentSimEvent : SimEvent {
    @private
		bool interestIsTaxable;
		double paymentAmt;
		double interestAmt;
}

@property bool interestIsTaxable;
@property double paymentAmt;
@property double interestAmt;

@end
