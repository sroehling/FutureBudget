//
//  DateSensitiveValueChange.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VariableDate;
@class FixedDate;

@interface DateSensitiveValueChange : NSManagedObject {
@private
}
@property (nonatomic, retain) VariableDate * startDate;
@property(nonatomic,retain) FixedDate *defaultFixedStartDate;
@property (nonatomic, retain) NSNumber * newValue;

@end
