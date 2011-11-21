//
//  DefaultInflationRate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "InflationRate.h"

@class SharedAppValues;

extern NSString * const DEFAULT_INFLATION_RATE_ENTITY_NAME;

@interface DefaultInflationRate : InflationRate {
@private
}

@property(nonatomic,retain) SharedAppValues *sharedAppValsDefaultInflationRate;

@end
