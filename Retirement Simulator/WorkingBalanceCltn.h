//
//  WorkingBalanceList.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WorkingBalance.h"

@class BalanceAdjustment;
@class Input;

@interface WorkingBalanceCltn : NSObject {
    @private
		NSMutableArray *workingBalList;
		NSMutableDictionary *inputWorkingBalMap;
		bool needsSorting;
		
}

- (void)addBalance:(id<WorkingBalance>)workingBal forInput:(Input*)theInput;
- (void)addBalance:(id<WorkingBalance>)workingBal;
- (id<WorkingBalance>)getWorkingBalanceForInput:(Input*)theInput;

- (void)carryBalancesForward:(NSDate*)newDate;
- (void)advanceBalancesToDate:(NSDate*)newDate;
- (void) resetCurrentBalances;
- (double)totalBalances:(NSDate*)currentDate;
- (void)sortByWithdrawalOrder;

@property(nonatomic,retain) NSMutableArray *workingBalList;
@property(nonatomic,retain) NSMutableDictionary *inputWorkingBalMap;


@end
