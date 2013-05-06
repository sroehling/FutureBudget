//
//  AccountDividendDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/6/13.
//
//

#import <Foundation/Foundation.h>
#import "DigestEntry.h"

@class AccountSimInfo;

@interface AccountDividendDigestEntry : NSObject <DigestEntry>
{
    @private
		AccountSimInfo *acctSimInfo;
}

@property(nonatomic,retain) AccountSimInfo *acctSimInfo;

-(id)initWithAcctSimInfo:(AccountSimInfo*)theSimInfo;

@end
