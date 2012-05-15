//
//  YearValXYPlotData.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YearValXYPlotData : NSObject {
    @private
		NSMutableArray *plotData;
}

@property(nonatomic,retain) NSMutableArray *plotData;

-(double)getUnadjustedYValforYear:(NSInteger)year;
-(double)getAdjustedYValforYear:(NSInteger)year;


-(double)maxYVal:(BOOL)adjustToStartDate;
-(double)minYVal:(BOOL)adjustToStartDate;



-(void)addPlotDataPointForYear:(NSInteger)year andYVal:(double)yVal 
		andSimStartValueMultiplier:(double)simStartAdjustmentMultiplier;

@end
