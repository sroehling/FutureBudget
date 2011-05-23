//
//  VariableValue.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DateSensitiveValue.h"

@class DateSensitiveValueChange;

@interface VariableValue : DateSensitiveValue {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * startingValue;
@property (nonatomic, retain) NSSet* valueChanges;

- (void)addValueChangesObject:(DateSensitiveValueChange *)value;

@end
