//
//  NeverEndDate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SimDate.h"

extern NSString * const NEVER_END_DATE_ENTITY_NAME;
extern NSString * const NEVER_END_PSEUDO_END_DATE;

@class SharedAppValues;

@interface NeverEndDate : SimDate {
@private
}

@property (nonatomic, retain) SharedAppValues * sharedAppValsNeverEndDate;


@end
