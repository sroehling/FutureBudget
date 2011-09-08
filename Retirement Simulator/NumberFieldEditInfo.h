//
//  NumberFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"
#import "ManagedObjectFieldEditInfo.h"

@class NumberFieldCell;
@class FieldInfo;

@interface NumberFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
@private  
    NSNumberFormatter *numberFormatter;

}

@property (nonatomic, retain) NSNumberFormatter *numberFormatter;

+ (NumberFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
                               andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder
					 andNumberFormatter:(NSNumberFormatter*)numFormatter;
					 
- (id) initWithFieldInfo:(FieldInfo *)theFieldInfo 
      andNumberFormatter:(NSNumberFormatter*)numFormatter;

@end
