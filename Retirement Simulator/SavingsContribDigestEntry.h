//
//  SavingsContribDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SavingsWorkingBalance;


@interface SavingsContribDigestEntry : NSObject {
    @private
		SavingsWorkingBalance *workingBalance;
		double contribAmount;
}

- (id) initWithWorkingBalance:(SavingsWorkingBalance*)theBalance andContribAmount:(double)theAmount;

@property(nonatomic,retain) SavingsWorkingBalance *workingBalance;
@property(readonly) double contribAmount;

@end
