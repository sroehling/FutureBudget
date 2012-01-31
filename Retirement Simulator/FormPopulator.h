//
//  FormPopulator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FormInfo;
@class SectionInfo;
@protocol FormInfoCreator;

@interface FormPopulator : NSObject {
    @private
        FormInfo *formInfo;
		SectionInfo *currentSection;
		UIViewController *parentController;
}

@property(nonatomic,retain) FormInfo *formInfo;
@property(nonatomic,retain) SectionInfo *currentSection;
@property(nonatomic,assign) UIViewController *parentController;

// Advance to the next section, allocating a default SectionInfo Object
- (SectionInfo*) nextSection;
- (SectionInfo*)nextSectionWithTitle:(NSString*)sectionTitle;
- (SectionInfo*)nextSectionWithTitle:(NSString *)sectionTitle 
		andHelpFile:(NSString*)helpInfoFile;

// Advance to the next section, using a custom 
// SectionInfo object (derived from SectionInfo)
- (void)nextCustomSection:(SectionInfo*)customSection;

- (id) initWithParentController:(UIViewController*)theParentController;

-(void)populateStaticNavFieldWithFormInfoCreator:(id<FormInfoCreator>)formInfoCreator
	andFieldCaption:(NSString*)caption andSubTitle:(NSString*)subTitle;
-(void)populateStaticNavFieldWithReadOnlyFormInfoCreator:(id<FormInfoCreator>)formInfoCreator
	andFieldCaption:(NSString*)caption andSubTitle:(NSString*)subTitle;
	
@end
