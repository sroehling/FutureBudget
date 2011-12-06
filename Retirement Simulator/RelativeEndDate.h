//
//  RelativeEndDate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SimDate.h"

extern NSString * const RELATIVE_END_DATE_ENTITY_NAME;
extern NSString * const RELATIVE_END_DATE_MONTHS_OFFSET_KEY;

@class SharedAppValues;

#define RELATIVE_END_DATE_NUM_INCREMENT_TYPES 4


@interface RelativeEndDate : SimDate {
@private
}

@property (nonatomic, retain) NSNumber * monthsOffset;

@property (nonatomic, retain) SharedAppValues * sharedAppValuesDefaultRelEndDate;

- (NSString *)relativeDateDescription;


@end
