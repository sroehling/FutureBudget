//
//  FiscalYearDigest.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CashWorkingBalance;
@class WorkingBalanceMgr;
@class SavingsContribDigestEntry;
@class BalanceAdjustment;
@class CashFlowSummations;

#import "IncomeTaxRateCalculator.h"

@interface FiscalYearDigest : NSObject {
    @private
		CashFlowSummations *cashFlowSummations;
		NSDate *startDate;
		WorkingBalanceMgr *workingBalanceMgr;
		id<IncomeTaxRateCalculator> incomeTaxRateCalc;
		
		NSMutableArray *savedEndOfYearResults;
}

-(id)initWithStartDate:(NSDate*)theStartDate andWorkingBalances:(WorkingBalanceMgr*)wbMgr;

- (void)advanceToNextYear;

@property(nonatomic,retain) NSDate *startDate;
@property(nonatomic,retain) WorkingBalanceMgr *workingBalanceMgr;
@property(nonatomic,retain) CashFlowSummations *cashFlowSummations;
@property(nonatomic,retain) id<IncomeTaxRateCalculator> incomeTaxRateCalc;
@property(nonatomic,retain) NSMutableArray *savedEndOfYearResults;

@end
