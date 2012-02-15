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
#import "FormContext.h"


@implementation FormPopulator

@synthesize currentSection;
@synthesize formContext;
@synthesize formInfo;

- (id) initWithFormContext:(FormContext*)theFormContext
{
    self = [super init];
    if(self)
    {
        self.formInfo = [[[FormInfo alloc] init] autorelease];
		
		assert(theFormContext != nil);
		self.formContext = theFormContext;
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
	[currentSection release];
	[formContext release];
    [formInfo release];
	[super dealloc];
}

- (SectionInfo*)nextSection
{
    SectionInfo *nextSection = [[[SectionInfo alloc]initWithFormContext:self.formContext] autorelease];
	self.currentSection = nextSection;
	nextSection.sectionHeader.formContext = self.formContext;
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

-(void)populateStaticNavFieldWithReadOnlyFormInfoCreator:(id<FormInfoCreator>)formInfoCreator
	andFieldCaption:(NSString*)caption andSubTitle:(NSString*)subTitle
{
	assert([StringValidation nonEmptyString:caption]);
	assert(formInfoCreator != nil);
		
	StaticNavFieldEditInfo *staticNavFieldEditInfo = 
		[[[StaticNavFieldEditInfo alloc] 
			initForReadOnlyViewWithCaption:caption
			andSubtitle:subTitle 
			andContentDescription:nil
			andSubFormInfoCreator:formInfoCreator] autorelease];
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:staticNavFieldEditInfo];
}


@end
