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
- (void)carryBalanceForward:(NSDate*)newStartDate;
- (void)advanceCurrentBalanceToDate:(NSDate*)newDate;

- (NSString*)balanceName;
- (bool)doTaxWithdrawals;
- (void)logBalance;

@property(nonatomic,retain) NSDate *balanceStartDate;
@property(nonatomic,retain) NSDate *currentBalanceDate;
@property(readonly) double startingBalance;
@property(readonly) double currentBalance;

@end
