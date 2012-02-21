//
//  YearValXYPlotResultsViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

#import "ResultsViewController.h"

@class CPTXYGraph;

@protocol YearValXYPlotDataGenerator;
@class YearValXYPlotData;

@interface YearValXYPlotResultsViewController : ResultsViewController  <CPTPlotDataSource> {
	@private
		CPTXYGraph *graph;
		
		
						
		id<YearValXYPlotDataGenerator> plotDataGenerator;
		YearValXYPlotData *currentData;
}

@property(nonatomic,retain) id<YearValXYPlotDataGenerator> plotDataGenerator;
@property(nonatomic,retain) YearValXYPlotData *currentData;

-(id)initWithResultsViewInfo:(ResultsViewInfo *)theViewInfo andPlotDataGenerator:(id<YearValXYPlotDataGenerator>)thePlotDataGenerator;


@end
