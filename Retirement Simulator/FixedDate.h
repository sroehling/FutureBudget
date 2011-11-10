//
//  FixedDate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SimDate.h"

@class DateSensitiveValueChange;
@class SharedAppValues;

@interface FixedDate : SimDate {
@private
}

//Inverse relationship
@property (nonatomic, retain) DateSensitiveValueChange * dateSensValChangeDefaultStartDate;
@property (nonatomic, retain) SharedAppValues * sharedAppValsDefaultFixedSimEndDate;


@end

extern NSString * const FIXED_DATE_ENTITY_NAME;
