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
@class Input;



@interface WorkingBalanceCltn : NSObject {
    @private
		NSMutableArray *workingBalList;
		NSMutableDictionary *inputWorkingBalMap;
		bool needsSorting;
		
}

- (void)addBalance:(WorkingBalance*)workingBal forInput:(Input*)theInput;
- (void)addBalance:(WorkingBalance*)workingBal;
- (WorkingBalance*)getWorkingBalanceForInput:(Input*)theInput;

- (void)carryBalancesForward:(NSDate*)newDate;
- (void)advanceBalancesToDate:(NSDate*)newDate;
- (void) resetCurrentBalances;
- (void)logCurrentBalances;
- (double)totalBalances;
- (void)sortByWithdrawalOrder;

@property(nonatomic,retain) NSMutableArray *workingBalList;
@property(nonatomic,retain) NSMutableDictionary *inputWorkingBalMap;


@end
