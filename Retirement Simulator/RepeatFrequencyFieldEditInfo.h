//
//  RepeatFrequencyFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"
#import "ManagedObjectFieldEditInfo.h"

@interface RepeatFrequencyFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
    
}

+ (RepeatFrequencyFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
                                        andLabel:(NSString*)label;

@end
