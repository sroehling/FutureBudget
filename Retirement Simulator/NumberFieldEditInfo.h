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

@interface NumberFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
@private
    NumberFieldCell *numberCell;    
    NSNumberFormatter *numberFormatter;

}

@property (nonatomic, assign) IBOutlet NumberFieldCell *numberCell;

@property (nonatomic, retain) NSNumberFormatter *numberFormatter;

+ (NumberFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
                               andLabel:(NSString*)label 
                     andNumberFormatter:(NSNumberFormatter*)numFormatter;
- (id) initWithFieldInfo:(ManagedObjectFieldInfo *)theFieldInfo 
      andNumberFormatter:(NSNumberFormatter*)numFormatter;

@end
