//
//  WorkingBalance.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BalanceAdjustment;


@interface WorkingBalance : NSObject {
    @protected
		NSDate *balanceStartDate;
		double startingBalance;
		double currentBalance;
		NSDate *currentBalanceDate;
}

- (void) incrementBalance:(double)amount asOfDate:(NSDate*)newDate;
- (void) decrementBalance:(double)amount asOfDate:(NSDate*)newDate;
- (BalanceAdjustment*) decrementAvailableBalance:(double)amount asOfDate:(NSDate*)newDate;

- (id) initWithStartingBalance:(double)theStartBalance 
	andStartDate:(NSDate*)theStartDate;
	
- (void)resetCurrentBalance;
- (BalanceAdjustment*)advanceCurrentBalanceToDate:(NSDate*)newDate;
- (BalanceAdjustment*)carryBalanceForward:(NSDate*)newStartDate;

- (NSString*)balanceName;
- (bool)doTaxWithdrawals;
- (bool)doTaxInterest;
- (void)logBalance;

@property(nonatomic,retain) NSDate *balanceStartDate;
@property(nonatomic,retain) NSDate *currentBalanceDate;
@property(readonly) double startingBalance;
@property(readonly) double currentBalance;

@end
