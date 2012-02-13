//
//  ManagedObjectFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldInfo.h"

@interface ManagedObjectFieldEditInfo : NSObject {

    FieldInfo *fieldInfo;
	BOOL isDefaultSelection;
}

@property (nonatomic, retain) FieldInfo *fieldInfo;
@property BOOL isDefaultSelection;

- (id) initWithFieldInfo:(FieldInfo*)theFieldInfo;
- (NSString*) textLabel;

- (BOOL)fieldIsInitializedInParentObject;
- (void)disableFieldAccess;

- (NSManagedObject*) managedObject;

@end
