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
	@private
		BoolFieldCell *boolCell;
}

@property (nonatomic, retain) BoolFieldCell *boolCell;

- (id)initWithFieldInfo:(FieldInfo *)theFieldInfo
	andSubtitle:(NSString*)subTitle;

+ (BoolFieldEditInfo*)createForObject:(NSManagedObject*)obj 
		andKey:(NSString*)key
        andLabel:(NSString*)label;

@end
