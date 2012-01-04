//
//  LoanEarlyPayoffDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DigestEntry.h"

@class LoanSimInfo;

@interface LoanEarlyPayoffDigestEntry : NSObject <DigestEntry> {
    @private
		LoanSimInfo *loanInfo;
}

- (id)initWithLoanInfo:(LoanSimInfo*)theLoanInfo;

@property(nonatomic,retain) LoanSimInfo *loanInfo;

@end
