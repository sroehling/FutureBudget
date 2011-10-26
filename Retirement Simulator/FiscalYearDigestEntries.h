//
//  CashFlowSummations.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DigestEntryCltn;
@protocol DigestEntry;

@interface FiscalYearDigestEntries : NSObject {
    @private
		NSArray *dailyDigestEntries;
		NSDate *startDate;
}

-(id)initWithStartDate:(NSDate*)startDate;

-(void)addDigestEntry:(id<DigestEntry>)digestEntry onDate:(NSDate*)entryDate;

- (void)markEndDateForEstimatedTaxAccrual:(NSDate*)taxEndDate;
- (void)markDateForEstimatedTaxPayment:(NSDate*)taxPaymentDate;

- (void)resetEntries;
- (DigestEntryCltn*)entriesForDayIndex:(NSInteger)dayIndex;
- (DigestEntryCltn*)entriesForDate:(NSDate*)eventDate;
- (void)resetEntriesAndAdvanceStartDate:(NSDate*)newStartDate;


@property(nonatomic,retain) NSDate *startDate;
@property(nonatomic,retain) NSArray *dailyDigestEntries;

@end
