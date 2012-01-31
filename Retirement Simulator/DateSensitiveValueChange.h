//
//  DateSensitiveValueChange.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const DATE_SENSITIVE_VALUE_CHANGE_START_DATE_SORT_KEY;
extern NSString * const DATE_SENSITIVE_VALUE_CHANGE_ENTITY_NAME;
extern NSString * const DATE_SENSITIVE_VALUE_CHANGE_START_DATE_KEY;
extern NSString * const DATE_SENSITIVE_VALUE_CHANGE_NEW_VALUE_KEY;



@class SimDate;
@class FixedDate;
@class VariableValue;

@interface DateSensitiveValueChange : NSManagedObject {
@private
}
@property (nonatomic, retain) SimDate * startDate;
@property(nonatomic,retain) FixedDate *defaultFixedStartDate;
@property (nonatomic, retain) NSNumber * newValue;

// Inverse property
@property (nonatomic, retain) VariableValue * variableValueValueChange;



// The resolvedStartDate method is needed so that calculations involving
// the start date can sort the DateSensitiveChange objects by the actual start
// date, given as an NSDate object, rather than VariableDate object.
-(NSDate*)resolvedStartDate;

@end

