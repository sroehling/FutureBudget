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

@synthesize currentSection;

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
	[currentSection release];
}

- (SectionInfo*)nextSection
{
    SectionInfo *nextSection = [[[SectionInfo alloc]init] autorelease];
	self.currentSection = nextSection;
    [formInfo addSection:nextSection];
    return nextSection;
}

- (void)nextCustomSection:(SectionInfo*)customSection
{
	self.currentSection = customSection;
    [formInfo addSection:customSection];
}


@end
