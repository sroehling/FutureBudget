//
//  SimParams.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Scenario;
@class InputSimInfoCltn;
@class InputValDigestSummations;
@class TaxInputCalcs;
@class WorkingBalanceMgr;
@class SharedAppValues;
@class FixedValue;
@class InflationRate;

@interface SimParams : NSObject {
	@private
		NSDate *simStartDate;
		NSDate *digestStartDate;
		NSDate *simEndDate;
		
		Scenario *simScenario;
		
		InputSimInfoCltn *incomeInfo;
		InputSimInfoCltn *expenseInfo;
		InputSimInfoCltn *acctInfo;
		InputSimInfoCltn *assetInfo;
		InputSimInfoCltn *loanInfo;

		InputValDigestSummations *digestSums;
		
		TaxInputCalcs *taxInputCalcs;
		
		WorkingBalanceMgr *workingBalanceMgr;
		
		InflationRate *inflationRate;
}

@property(nonatomic,retain) NSDate *simStartDate;
@property(nonatomic,retain) NSDate *digestStartDate;
@property(nonatomic,retain) NSDate *simEndDate;


@property(nonatomic,retain) Scenario *simScenario;

@property(nonatomic,retain) InputSimInfoCltn *incomeInfo;
@property(nonatomic,retain) InputSimInfoCltn *expenseInfo;
@property(nonatomic,retain) InputSimInfoCltn *acctInfo;
@property(nonatomic,retain) InputSimInfoCltn *assetInfo;
@property(nonatomic,retain) InputSimInfoCltn *loanInfo;

@property(nonatomic,retain) InputValDigestSummations *digestSums;
@property(nonatomic,retain) TaxInputCalcs *taxInputCalcs;
@property(nonatomic,retain) WorkingBalanceMgr *workingBalanceMgr;
@property(nonatomic,retain) InflationRate *inflationRate;

-(id)initWithStartDate:(NSDate*)simStart andDigestStartDate:(NSDate*)digestStart
	andSimEndDate:(NSDate*)simEnd andScenario:(Scenario*)scen andCashBal:(double)cashBal
	andDeficitRate:(FixedValue*)deficitRate andDeficitBalance:(double)startingDeficitBal
	andInflationRate:(InflationRate*)theInflationRate;	
	
-(id)initWithSharedAppVals:(SharedAppValues*)sharedAppVals;


@end
