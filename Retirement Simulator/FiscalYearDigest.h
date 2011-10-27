//
//  FiscalYearDigest.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WorkingBalanceMgr;
@class FiscalYearDigestEntries;
@class SimParams;

@interface FiscalYearDigest : NSObject {
    @private
		FiscalYearDigestEntries *digestEntries;
		NSDate *currentYearDigestStartDate;
		NSMutableArray *savedEndOfYearResults;
		SimParams *simParams;
}

-(id)initWithSimParams:(SimParams*)theSimParams;

- (void)advanceToNextYear;


@property(nonatomic,retain) FiscalYearDigestEntries *digestEntries;
@property(nonatomic,retain) NSMutableArray *savedEndOfYearResults;
@property(nonatomic,retain) SimParams *simParams;
@property(nonatomic,retain) NSDate *currentYearDigestStartDate;

@end
