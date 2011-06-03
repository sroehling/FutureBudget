//
//  VariableDateFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"
#import "ManagedObjectFieldEditInfo.h"

@interface VariableDateFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
    
}

+ (VariableDateFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
                                        andLabel:(NSString*)label;
@end
