//
//  DateSensitiveValueFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManagedObjectFieldEditInfo.h"

#import "FieldEditInfo.h"

@interface DateSensitiveValueFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
    @private 
    NSString *variableValueEntityName;
    ManagedObjectFieldInfo *defafaultFixedValFieldInfo;
}

@property(nonatomic,retain) NSString *variableValueEntityName;

- (id)initWithFieldInfo:(ManagedObjectFieldInfo *)theFieldInfo andDefaultFixedValFieldInfo:(ManagedObjectFieldInfo*)theDefaultFieldInfo;

@property(nonatomic,retain) ManagedObjectFieldInfo *defafaultFixedValFieldInfo;

+ (DateSensitiveValueFieldEditInfo*)createForObject:(NSManagedObject*)obj 
                                             andKey:(NSString*)key
      andLabel:(NSString*)label andEntityName:(NSString*)entityName
        andDefaultFixedValKey:(NSString*)defaultFixedValKey;

@end
