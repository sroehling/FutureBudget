//
//  YearValXYPlotDataGenerator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YearValXYPlotData;
@class SimResults;

@protocol YearValXYPlotDataGenerator <NSObject>

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResults*)simResults;
-(NSString*)dataLabel;
-(NSString*)dataYearlyUnitLabel;
-(BOOL)resultsDefinedInSimResults:(SimResults*)simResults;

@end
