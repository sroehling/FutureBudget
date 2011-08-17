//
//  CashWorkingBalance.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CashWorkingBalance : NSObject {
    @private
		NSDate *balanceStartDate;
		double startingBalance;
		double currentBalance;
}

- (void) incrementBalance:(double)amount;
- (void) decrementBalance:(double)amount;

- (id) initWithStartDate:(NSDate*)theStartDate andStartingBalance:(double)theStartBalance;
- (void)resetCurrentBalance;
- (void)carryBalanceForward:(NSDate*)newStartDate;

@property(nonatomic,retain) NSDate *balanceStartDate;
@property(readonly) double startingBalance;
@property(readonly) double currentBalance;

@end
