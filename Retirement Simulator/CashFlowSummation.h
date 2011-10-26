//
//  CashFlowSummation.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SavingsContribDigestEntry;
@class LoanPmtDigestEntry;

@protocol DigestEntry;

@interface CashFlowSummation : NSObject {
    @private
		NSMutableArray *digestEntries;
		
		bool isEndDateForEstimatedTaxes;
		bool isEstimatedTaxPaymentDay;
}

- (void)addDigestEntry:(id<DigestEntry>)digestEntry;

- (void)markAsEndDateForEstimatedTaxAccrual;
- (void)markAsEstimatedTaxPaymentDay;

- (void)resetSummations;

@property(nonatomic,retain) NSMutableArray *digestEntries;
@property(readonly) bool isEndDateForEstimatedTaxes;
@property(readonly) bool isEstimatedTaxPaymentDay;

@end
