//
//  YearValXYPlotDataGenerator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YearValXYPlotData;
@class SimResultsController;

@protocol YearValXYPlotDataGenerator <NSObject>

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults;
-(NSString*)dataLabel;
-(BOOL)resultsDefinedInSimResults:(SimResultsController*)simResults;

@end
