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
		double minYVal;
		double maxYVal;
}

@property(nonatomic,retain) NSMutableArray *plotData;
@property double minYVal;
@property double maxYVal;

-(void)addPlotDataPointForYear:(NSInteger)year andYVal:(double)yVal;

@end
