//
//  LoanPmtDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DigestEntry.h"
#import "LoanPmtAmtCalculator.h"

@class LoanSimInfo;

@interface LoanPmtDigestEntry : NSObject <DigestEntry> {
    @private
		LoanSimInfo *loanInfo;
		id<LoanPmtAmtCalculator> pmtCalculator;

}

@property(nonatomic,retain) LoanSimInfo *loanInfo;
@property(nonatomic,retain) id<LoanPmtAmtCalculator> pmtCalculator;

-(id)initWithLoanInfo:(LoanSimInfo*)theLoanInfo andPmtCalculator:(id<LoanPmtAmtCalculator>)thePmtCalculator;

@end
