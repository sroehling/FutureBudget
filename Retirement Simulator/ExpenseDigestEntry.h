//
//  ExpenseDigestEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CashFlowDigestEntry.h"
#import "DigestEntry.h"

@class ExpenseSimInfo;

@interface ExpenseDigestEntry : CashFlowDigestEntry <DigestEntry> {
    @private
		ExpenseSimInfo *expenseInfo;
}

- (id)initWithExpenseInfo:(ExpenseSimInfo*)theExpenseInfo andAmount:(double)theAmount;

@property(nonatomic,retain) ExpenseSimInfo *expenseInfo;

@end
