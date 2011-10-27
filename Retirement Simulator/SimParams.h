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

@interface SimParams : NSObject {
	@private
		NSDate *simStartDate;
		NSDate *digestStartDate;
		NSDate *simEndDate;
		
		Scenario *simScenario;
		
		InputSimInfoCltn *incomeInfo;
		InputSimInfoCltn *expenseInfo;

		InputValDigestSummations *digestSums;
		
		TaxInputCalcs *taxInputCalcs;
		
		WorkingBalanceMgr *workingBalanceMgr;
		
    
}

@property(nonatomic,retain) NSDate *simStartDate;
@property(nonatomic,retain) NSDate *digestStartDate;
@property(nonatomic,retain) NSDate *simEndDate;


@property(nonatomic,retain) Scenario *simScenario;

@property(nonatomic,retain) InputSimInfoCltn *incomeInfo;
@property(nonatomic,retain) InputSimInfoCltn *expenseInfo;

@property(nonatomic,retain) InputValDigestSummations *digestSums;
@property(nonatomic,retain) TaxInputCalcs *taxInputCalcs;
@property(nonatomic,retain) WorkingBalanceMgr *workingBalanceMgr;

- (id)initWithStartDate:(NSDate*)startDate andScenario:(Scenario*)scenario;


@end
