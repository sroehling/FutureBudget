//
//  StaticFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StaticFormInfoCreator.h"
#import "FormInfo.h"
#import "FormContext.h"

@implementation StaticFormInfoCreator

@synthesize formInfo;

- (id) initWithFormInfo:(FormInfo*)theFormInfo
{
    self = [super init];
    if(self)
    {
        assert(theFormInfo != nil);
        self.formInfo = theFormInfo;
        
    }
    return self;
}

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
    return self.formInfo;
}

- (id) init
{
    assert(0); // should not be called
}

+ (StaticFormInfoCreator*)createWithFormInfo:(FormInfo*)theFormInfo
{
    return [[[StaticFormInfoCreator alloc] initWithFormInfo:theFormInfo] autorelease];
}

- (void) dealloc
{
    [formInfo release];
    [super dealloc];
}

@end
