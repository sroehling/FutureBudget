//
//  EndOfYearDigestResult.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EndOfYearDigestResult : NSObject {
    @private
		NSDate *endDate;
		double totalEndOfYearBalance;
}

@property(nonatomic,retain) NSDate *endDate;
@property double totalEndOfYearBalance;

-(id)initWithEndDate:(NSDate*)endOfYearDate;

- (NSInteger)yearNumber;

- (void)logResults;

@end
