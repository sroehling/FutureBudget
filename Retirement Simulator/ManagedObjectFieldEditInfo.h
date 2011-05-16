//
//  ManagedObjectFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ManagedObjectFieldInfo.h"

@interface ManagedObjectFieldEditInfo : NSObject {

    ManagedObjectFieldInfo *fieldInfo;
}

@property (nonatomic, retain) ManagedObjectFieldInfo *fieldInfo;

- (id) initWithFieldInfo:(ManagedObjectFieldInfo*)theFieldInfo;
- (NSString*) textLabel;

@end
