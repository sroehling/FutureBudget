//
//  SavingsContribDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DigestEntry.h"

@class AccountSimInfo;


@interface AccountContribDigestEntry : NSObject <DigestEntry> {
    @private
		AccountSimInfo *acctSimInfo;
    @private
		double contribAmount;
}

- (id) initWithAcctSimInfo:(AccountSimInfo*)theAcctSimInfo
	andContribAmount:(double)theAmount;

@property(nonatomic,retain) AccountSimInfo *acctSimInfo;
@property double contribAmount;

@end
