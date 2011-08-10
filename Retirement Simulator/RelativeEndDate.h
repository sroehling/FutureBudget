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

@class RelativeEndDateInfo;

#define RELATIVE_END_DATE_NUM_INCREMENT_TYPES 4


@interface RelativeEndDate : SimDate {
@private
}
@property (nonatomic, retain) NSNumber * years;
@property (nonatomic, retain) NSNumber * months;
@property (nonatomic, retain) NSNumber * weeks;

- (RelativeEndDateInfo*)relEndDateInfo;
- (void)setWithRelEndDateInfo:(RelativeEndDateInfo*)theRelEndDateInfo;
- (NSString *)relativeDateDescription;


@end
