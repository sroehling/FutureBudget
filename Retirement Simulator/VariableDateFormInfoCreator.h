//
//  VariableDateFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"
#import "ManagedObjectFieldInfo.h"
#import "FixedDate.h"

@class VariableDateRuntimeInfo;

@interface VariableDateFormInfoCreator : NSObject <FormInfoCreator> {
    @private
        ManagedObjectFieldInfo *fieldInfo;
        FixedDate *fixedDate;
		VariableDateRuntimeInfo *varDateRuntimeInfo;
}

- (id)initWithVariableDateFieldInfo:(ManagedObjectFieldInfo*)vdFieldInfo 
             andDefaultValFieldInfo:(ManagedObjectFieldInfo*)theDefaultFieldInfo
			 andVarDateRuntimeInfo:(VariableDateRuntimeInfo*)theVarDateRuntimeInfo;

@property(nonatomic,retain) ManagedObjectFieldInfo *fieldInfo;
@property(nonatomic,retain) FixedDate *fixedDate;
@property(nonatomic,retain) VariableDateRuntimeInfo *varDateRuntimeInfo;

@end
