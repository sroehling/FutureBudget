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
}

@property(nonatomic,retain) NSString *variableValueEntityName;

+ (DateSensitiveValueFieldEditInfo*)createForObject:(NSManagedObject*)obj 
                                             andKey:(NSString*)key
      andLabel:(NSString*)label andEntityName:(NSString*)entityName;

@end
