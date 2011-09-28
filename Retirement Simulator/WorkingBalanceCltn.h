//
//  WorkingBalanceList.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WorkingBalance;
@class BalanceAdjustment;



@interface WorkingBalanceCltn : NSObject {
    @private
		NSMutableArray *workingBalList;
		bool needsSorting;
		
}

- (void)addBalance:(WorkingBalance*)workingBal;
- (void)carryBalancesForward:(NSDate*)newDate;
- (BalanceAdjustment*)advanceBalancesToDate:(NSDate*)newDate;
- (void) resetCurrentBalances;
- (void)logCurrentBalances;
- (double)totalBalances;
- (void)sortByWithdrawalOrder;

@property(nonatomic,retain) NSMutableArray *workingBalList;


@end
