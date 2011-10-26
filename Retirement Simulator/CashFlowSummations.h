//
//  CashFlowSummations.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CashFlowSummation;
@protocol DigestEntry;

@interface CashFlowSummations : NSObject {
    @private
		NSArray *cashFlowSummations;
		NSDate *startDate;
}

-(id)initWithStartDate:(NSDate*)startDate;

-(void)addDigestEntry:(id<DigestEntry>)digestEntry onDate:(NSDate*)entryDate;

- (void)markEndDateForEstimatedTaxAccrual:(NSDate*)taxEndDate;
- (void)markDateForEstimatedTaxPayment:(NSDate*)taxPaymentDate;

- (void)resetSummations;
- (CashFlowSummation*)summationForDayIndex:(NSInteger)dayIndex;
- (CashFlowSummation*)summationForDate:(NSDate*)eventDate;
- (void)resetSummationsAndAdvanceStartDate:(NSDate*)newStartDate;


@property(nonatomic,retain) NSDate *startDate;
@property(nonatomic,retain) NSArray *cashFlowSummations;

@end
