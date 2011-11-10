//
//  VariableDate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SimDateVisitor.h"

#import "InputValue.h"

extern NSString * const SIM_DATE_DATE_KEY;

@class DateSensitiveValueChange;
@class SharedAppValues;

@interface SimDate : InputValue {
@private
}
@property (nonatomic, retain) NSDate *date;

// Inverse Relationships
@property (nonatomic, retain) DateSensitiveValueChange * dateSensitiveValueChangeStartDate;
@property (nonatomic, retain) SharedAppValues * sharedAppValsSimEndDate;


- (NSString *)inlineDescription:(NSDateFormatter*)withFormat;
- (NSString *)dateLabel;

- (void)acceptVisitor:(id<SimDateVisitor>)visitor;
- (NSDate*)endDateWithStartDate:(NSDate*)startDate;

@end
