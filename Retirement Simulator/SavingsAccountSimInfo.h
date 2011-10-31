//
//  SavingsAccountSimInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SavingsAccount;
@class InterestBearingWorkingBalance;
@class SimParams;

@interface SavingsAccountSimInfo : NSObject {
    @private
		SavingsAccount *savingsAcct;
		InterestBearingWorkingBalance *savingsBal;
}

@property(nonatomic,retain) SavingsAccount *savingsAcct;
@property(nonatomic,retain) InterestBearingWorkingBalance *savingsBal;

-(id)initWithSavingsAcct:(SavingsAccount*)theSavingsAcct andSimParams:(SimParams *)simParams;

@end
