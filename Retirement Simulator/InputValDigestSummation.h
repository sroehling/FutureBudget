//
//  InputSummation.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InputValDigestSummation : NSObject {
    @private
		double *currentSum;
		double firstDaySum;
}

-(void)resetSum;


// When a digest summation is used to store interest calculations,
// it can result in some iterest carrying over from Dec 31st of the
// prior year into January 1st. This interest is calculated at the
// beginning of the year, before the digest is computed across the
// year. So, we need an ability to take a snapshot of the first
// day's sum, so we can rewind to this value when doing multiple
// passes of digest calculations.
-(void)snapshotSumAtStartDate;

// Rewind the digest results to the beginning of the year, but
// retain the first day sum (see snapshotSumAtStartDate) above.
-(void)rewindSumToStartDate;

-(void)adjustSum:(double)amount onDay:(NSInteger)dayIndex;


-(double)yearlyTotal;
-(double)dailySum:(NSInteger)dayIndex;

@end
