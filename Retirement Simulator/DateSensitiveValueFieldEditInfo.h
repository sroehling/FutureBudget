//
//  DateSensitiveValueFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ManagedObjectFieldEditInfo.h"
#import "VariableValueRuntimeInfo.h"
#import "FieldEditInfo.h"

@interface DateSensitiveValueFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
    @private 
		ManagedObjectFieldInfo *defafaultFixedValFieldInfo;
		VariableValueRuntimeInfo *varValRuntimeInfo;

}

@property(nonatomic,retain) VariableValueRuntimeInfo *varValRuntimeInfo;

- (id)initWithFieldInfo:(ManagedObjectFieldInfo *)theFieldInfo 
    andDefaultFixedValFieldInfo:(ManagedObjectFieldInfo*)theDefaultFieldInfo
      andValRuntimeInfo:(VariableValueRuntimeInfo *)varValRuntimeInfo;

@property(nonatomic,retain) ManagedObjectFieldInfo *defafaultFixedValFieldInfo;

+ (DateSensitiveValueFieldEditInfo*)createForObject:
			(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label andValRuntimeInfo:(VariableValueRuntimeInfo *)varValRuntimeInfo
				andDefaultFixedValKey:(NSString*)defaultFixedValKey;

@end
