//
//  SavingsContribDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InterestBearingWorkingBalance;
@class BalanceAdjustment;

@interface SavingsContribDigestEntry : NSObject {
    @private
		InterestBearingWorkingBalance *workingBalance;
		double contribAmount;
		bool contribIsTaxable;
		BalanceAdjustment *contribAdjustment;
}

- (id) initWithWorkingBalance:(InterestBearingWorkingBalance*)theBalance 
	andContribAmount:(double)theAmount andIsTaxable:(bool)isTaxable;

@property(nonatomic,retain) InterestBearingWorkingBalance *workingBalance;
@property(readonly) double contribAmount;
@property bool contribIsTaxable;
@property(nonatomic,retain) BalanceAdjustment *contribAdjustment;

@end
