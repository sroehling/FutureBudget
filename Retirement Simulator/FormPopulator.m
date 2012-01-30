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
#import "StringValidation.h"
#import "SectionHeaderWithSubtitle.h"
#import "FormInfoCreator.h"
#import "StaticNavFieldEditInfo.h"


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

- (SectionInfo*)nextSectionWithTitle:(NSString*)sectionTitle
{
	assert([StringValidation nonEmptyString:sectionTitle]);
	SectionInfo *nextSection = [self nextSection];
	nextSection.title = sectionTitle;
	return nextSection;
}

- (SectionInfo*)nextSectionWithTitle:(NSString *)sectionTitle 
		andHelpFile:(NSString*)helpInfoFile
{
	assert([StringValidation nonEmptyString:helpInfoFile]);
	SectionInfo *nextSection = [self nextSectionWithTitle:sectionTitle];
	nextSection.helpInfoHTMLFile = helpInfoFile;
	return nextSection;
}

- (void)nextCustomSection:(SectionInfo*)customSection
{
	self.currentSection = customSection;
    [formInfo addSection:customSection];
}

-(void)populateStaticNavFieldWithFormInfoCreator:(id<FormInfoCreator>)formInfoCreator
	andFieldCaption:(NSString*)caption andSubTitle:(NSString*)subTitle
{
	assert([StringValidation nonEmptyString:caption]);
	assert(formInfoCreator != nil);
		
	StaticNavFieldEditInfo *staticNavFieldEditInfo = 
		[[[StaticNavFieldEditInfo alloc] 
			initWithCaption:caption
			andSubtitle:subTitle 
			andContentDescription:nil
			andSubFormInfoCreator:formInfoCreator] autorelease];
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:staticNavFieldEditInfo];

}


@end
