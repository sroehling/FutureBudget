//
//  LoanPmtDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DigestEntry.h"
#import "LoanPmtProcessor.h"

@class LoanSimInfo;

@interface LoanPmtDigestEntry : NSObject <DigestEntry> {
    @private
		LoanSimInfo *loanInfo;
		id<LoanPmtProcessor> pmtProcessor;

}

@property(nonatomic,retain) LoanSimInfo *loanInfo;
@property(nonatomic,retain) id<LoanPmtProcessor> pmtProcessor;

-(id)initWithLoanInfo:(LoanSimInfo*)theLoanInfo andPmtProcessor:(id<LoanPmtProcessor>)thePmtProcessor;

@end
