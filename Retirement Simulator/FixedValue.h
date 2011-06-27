//
//  FixedValue.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DateSensitiveValue.h"


@interface FixedValue : DateSensitiveValue {
@private
}
@property (nonatomic, retain) NSNumber * value;

@end

extern NSString * const FIXED_VALUE_ENTITY_NAME;
