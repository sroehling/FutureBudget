//
//  WorkingBalance.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WorkingBalance : NSObject {
    @protected
		NSDate *balanceStartDate;
		double startingBalance;
		double currentBalance;
		NSDate *currentBalanceDate;
}

- (void) incrementBalance:(double)amount asOfDate:(NSDate*)newDate;
- (void) decrementBalance:(double)amount asOfDate:(NSDate*)newDate;
- (double) decrementAvailableBalance:(double)amount asOfDate:(NSDate*)newDate;

- (id) initWithStartingBalance:(double)theStartBalance;
- (void)resetCurrentBalance;
- (void)carryBalanceForward:(NSDate*)newStartDate;

@property(nonatomic,retain) NSDate *balanceStartDate;
@property(nonatomic,retain) NSDate *currentBalanceDate;
@property(readonly) double startingBalance;
@property(readonly) double currentBalance;

@end
