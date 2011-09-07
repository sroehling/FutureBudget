//
//  BoolInputValue.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "InputValue.h"

extern NSString * const BOOL_INPUT_VALUE_ENTITY_NAME;

@interface BoolInputValue : InputValue {
@private
}
@property (nonatomic, retain) NSNumber * isTrue;

@end
