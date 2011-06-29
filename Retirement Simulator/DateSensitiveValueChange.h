//
//  DateSensitiveValueChange.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SimDate;
@class FixedDate;

@interface DateSensitiveValueChange : NSManagedObject {
@private
}
@property (nonatomic, retain) SimDate * startDate;
@property(nonatomic,retain) FixedDate *defaultFixedStartDate;
@property (nonatomic, retain) NSNumber * newValue;


// The resolvedStartDate method is needed so that calculations involving
// the start date can sort the DateSensitiveChange objects by the actual start
// date, given as an NSDate object, rather than VariableDate object.
-(NSDate*)resolvedStartDate;

@end

extern NSString * const DATE_SENSITIVE_VALUE_CHANGE_START_DATE_SORT_KEY;
extern NSString * const DATE_SENSITIVE_VALUE_CHANGE_ENTITY_NAME;
