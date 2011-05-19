//
//  VariablePercentageRate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PercentageRate.h"

@class PercentageRateChange;

@interface VariablePercentageRate : PercentageRate {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * startingRate;
@property (nonatomic, retain) NSSet* rateChanges;

@end
