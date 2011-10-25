//
//  WorkingBalanceAdjustment.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BalanceAdjustment;

@interface WorkingBalanceAdjustment : NSObject {
    @private
		BalanceAdjustment *interestAdjustement;
		BalanceAdjustment *balanceAdjustment;
}

-(id)initWithBalanceAdjustment:(BalanceAdjustment*)balanceAdj
	andInterestAdjustment:(BalanceAdjustment*)interestAdj;
-(id)initWithZeroAmounts;

- (void)addAdjustment:(WorkingBalanceAdjustment*)otherAdj;

@property(nonatomic,retain) BalanceAdjustment *interestAdjustement;
@property(nonatomic,retain) BalanceAdjustment *balanceAdjustment; 

@end
