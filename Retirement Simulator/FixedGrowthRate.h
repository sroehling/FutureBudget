//
//  FixedGrowthRate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GrowthRate.h"


@interface FixedGrowthRate : GrowthRate {
@private
}
@property (nonatomic, retain) NSNumber * rate;

@end
