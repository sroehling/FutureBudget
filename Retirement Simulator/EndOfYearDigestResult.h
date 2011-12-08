//
//  EndOfYearDigestResult.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EndOfYearInputResults;

@interface EndOfYearDigestResult : NSObject {
    @private
		NSDate *endDate;
		double totalEndOfYearBalance;
		
		EndOfYearInputResults *assetValues;
		double sumAssetVals;
}

@property(nonatomic,retain) NSDate *endDate;
@property double totalEndOfYearBalance;

@property(nonatomic,retain) EndOfYearInputResults *assetValues;
@property double sumAssetVals;


-(id)initWithEndDate:(NSDate*)endOfYearDate;

- (NSInteger)yearNumber;

- (void)logResults;

@end
