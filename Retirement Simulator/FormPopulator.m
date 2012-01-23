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
#import "SectionHeaderWithSubtitle.h"


@implementation FormPopulator

@synthesize currentSection;
@synthesize parentController;

@synthesize formInfo;

- (id) initWithParentController:(UIViewController*)theParentController
{
    self = [super init];
    if(self)
    {
        self.formInfo = [[[FormInfo alloc] init] autorelease];
		self.parentController = theParentController;
    }
    return self;
}

- (id)init
{
	assert(0);
	return nil;
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
	nextSection.sectionHeader.parentController = self.parentController;
    [formInfo addSection:nextSection];
    return nextSection;
}

- (void)nextCustomSection:(SectionInfo*)customSection
{
	self.currentSection = customSection;
    [formInfo addSection:customSection];
}


@end
