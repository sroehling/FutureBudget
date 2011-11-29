//
//  InflationRate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VariableValue.h"

extern NSString * const INFLATION_RATE_ENTITY_NAME;

@class SharedAppValues;

@interface InflationRate : VariableValue {
@private
}

@property(nonatomic,retain) SharedAppValues *sharedAppValsDefaultInflationRate;

@end
