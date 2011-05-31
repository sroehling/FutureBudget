//
//  FormPopulator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormPopulator.h"
#import "SectionInfo.h"
#import "FormInfo.h"


@implementation FormPopulator

@synthesize formInfo;

- (id) init
{
    self = [super init];
    if(self)
    {
        self.formInfo = [[[FormInfo alloc] init] autorelease];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
    [formInfo release];
}

- (SectionInfo*)nextSection
{
    SectionInfo *nextSection = [[[SectionInfo alloc]init] autorelease];
    [formInfo addSection:nextSection];
    return nextSection;
}


@end
