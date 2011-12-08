//
//  YearValXYPlotResultsViewFactory.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ResultsViewFactory.h"

@protocol YearValXYPlotDataGenerator;

@interface YearValXYPlotResultsViewFactory : ResultsViewFactory {
    @private
		id<YearValXYPlotDataGenerator> plotDataGenerator;
}

@property(nonatomic,retain) id<YearValXYPlotDataGenerator> plotDataGenerator;

-(id)initWithResultsViewInfo:(ResultsViewInfo *)theResultsViewInfo 
	andPlotDataGenerator:(id<YearValXYPlotDataGenerator>)theDataGenerator;

@end
