//
//  BoolFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManagedObjectFieldEditInfo.h"
#import "FieldEditInfo.h"

@class BoolFieldCell;

@interface BoolFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
}

@property (nonatomic, assign) IBOutlet BoolFieldCell *boolCell;

+ (BoolFieldEditInfo*)createForObject:(NSManagedObject*)obj 
		andKey:(NSString*)key
        andLabel:(NSString*)label;

@end
