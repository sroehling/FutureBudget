//
//  DateSensitiveValueFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FixedValue;
@class ManagedObjectFieldInfo;
#import "FormInfoCreator.h"

@interface DateSensitiveValueFormInfoCreator : NSObject <FormInfoCreator> {
    @private
        ManagedObjectFieldInfo *fieldInfo;
        FixedValue *defaultFixedVal;
        NSString *varValueEntityName;
}

- (id)initWithVariableValueFieldInfo:(ManagedObjectFieldInfo*)vvFieldInfo
                  andDefaultFixedVal:(FixedValue*)theDefaultFixedVal
               andVarValueEntityName:(NSString*)entityName;

@property(nonatomic,retain) FixedValue *defaultFixedVal;
@property(nonatomic,retain) ManagedObjectFieldInfo *fieldInfo;
@property(nonatomic,retain) NSString *varValueEntityName;

@end
