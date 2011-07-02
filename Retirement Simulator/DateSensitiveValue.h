//
//  DateSensitiveValue.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "InputValue.h"

@class VariableValueRuntimeInfo;
@protocol DateSensitiveValueVisitor;

@interface DateSensitiveValue : InputValue {
@private
}

- (NSString*) valueDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo;
- (NSString*) valueSubtitle:(VariableValueRuntimeInfo*)valueRuntimeInfo;
- (NSString*) inlineDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo;
- (NSString*) standaloneDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo;

-(void)acceptDateSensitiveValVisitor:(id<DateSensitiveValueVisitor>)dsvVisitor;

@end
