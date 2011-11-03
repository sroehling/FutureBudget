//
//  SavingsContribDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DigestEntry.h"

@class InterestBearingWorkingBalance;


@interface AccountContribDigestEntry : NSObject <DigestEntry> {
    @private
		InterestBearingWorkingBalance *workingBalance;
		double contribAmount;
}

- (id) initWithWorkingBalance:(InterestBearingWorkingBalance*)theBalance 
	andContribAmount:(double)theAmount;

@property(nonatomic,retain) InterestBearingWorkingBalance *workingBalance;
@property double contribAmount;

@end
