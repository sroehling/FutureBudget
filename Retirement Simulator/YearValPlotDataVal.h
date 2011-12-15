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
		NSNumber *val;
}

@property(nonatomic,retain) NSNumber *year;
@property(nonatomic,retain) NSNumber *val;

-(id)initWithYear:(NSInteger)theYear andVal:(double)theVal;

@end
