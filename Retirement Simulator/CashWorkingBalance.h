//
//  CashWorkingBalance.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WorkingBalanceBaseImpl.h"

@interface CashWorkingBalance : WorkingBalanceBaseImpl {
}

- (id) initWithStartingBalance:(double)theStartBalance
		andStartDate:(NSDate *)theStartDate;

@end
