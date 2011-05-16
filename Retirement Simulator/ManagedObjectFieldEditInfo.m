//
//  ManagedObjectFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ManagedObjectFieldEditInfo.h"


@implementation ManagedObjectFieldEditInfo

@synthesize fieldInfo;

- (id) initWithFieldInfo:(ManagedObjectFieldInfo *)theFieldInfo
{
    self = [super init];
    if(self)
    {
        assert(theFieldInfo != nil);
        self.fieldInfo = theFieldInfo;
    }
    return self;
}


- (NSString*) textLabel
{
    return [fieldInfo textLabel];
}

@end
