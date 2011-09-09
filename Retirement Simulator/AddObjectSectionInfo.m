//
//  AddObjectSectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddObjectSectionInfo.h"
#import "SectionHeaderWithSubtitle.h"


@implementation AddObjectSectionInfo


@synthesize parentViewController;

- (id) init
{
	self = [super init];
	if(self)
	{
		assert(self.sectionHeader != nil);
		self.sectionHeader.addButtonDelegate = self;
	}
	return self;
}

- (void)addButtonPressedInSectionHeader
{
    // no-op
    assert(0); // must be overriden
}




@end
