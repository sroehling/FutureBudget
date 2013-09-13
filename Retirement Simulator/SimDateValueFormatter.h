//
//  SimDateValueFormatter.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimDateVisitor.h"

@class SimDate;
@class SimDateRuntimeInfo;
@class DateHelper;

@interface SimDateValueFormatter : NSObject <SimDateVisitor> {
    @private
		NSString *formattedVal;
		SimDateRuntimeInfo *simDateRuntimeInfo;
        DateHelper *dateHelper;
}

@property(nonatomic,retain) NSString *formattedVal;
@property(nonatomic,retain) SimDateRuntimeInfo *simDateRuntimeInfo;
@property(nonatomic,retain) DateHelper *dateHelper;

-(id)initWithSimDateRuntimeInfo:(SimDateRuntimeInfo*)sdRuntimeInfo;

- (NSString*)formatSimDate:(SimDate*)theSimDate;

@end
