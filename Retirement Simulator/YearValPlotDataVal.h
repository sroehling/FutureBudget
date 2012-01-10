//
//  YearValPlotDataVal.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YearValPlotDataVal : NSObject {
    @private
		NSNumber *year;
		NSNumber *unadjustedVal;
		NSNumber *inflationAdjustedVal;
		double simStartValueAdjustmentMultiplier;
}

@property(nonatomic,retain) NSNumber *year;
@property(nonatomic,retain) NSNumber *unadjustedVal;
@property(nonatomic,retain) NSNumber *inflationAdjustedVal;
@property double simStartValueAdjustmentMultiplier;

-(id)initWithYear:(NSInteger)theYear andVal:(double)theVal
	andSimStartValueAdjustmentMultiplier:(double)theSimStartValMult;

@end
