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

extern NSString * const FIXED_VALUE_ENTITY_NAME;
extern NSString * const FIXED_VALUE_VALUE_KEY;

@interface FixedValue : DateSensitiveValue {
@private
}
@property (nonatomic, retain) NSNumber * value;

@end


