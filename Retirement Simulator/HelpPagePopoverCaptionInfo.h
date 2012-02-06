//
//  HelpPagePopoverCaptionInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TextCaptionWEPopoverContainer.h"

@interface HelpPagePopoverCaptionInfo : NSObject{
    @private
		NSString *popoverCaption;
		NSString *helpPageMoreInfoCaption;
		NSString *helpPageName;
		UIViewController *parentController;
}

@property(nonatomic,retain) NSString *popoverCaption;
@property(nonatomic,retain) NSString *helpPageMoreInfoCaption;
@property(nonatomic,retain) NSString *helpPageName;
@property(nonatomic,assign) UIViewController *parentController;

-(id)initWithPopoverCaption:(NSString*)thePopoverCaption
	andHelpPageMoreInfoCaption:(NSString*)moreInfoCaption
	andHelpPageName:(NSString*)theHelpPageName
	andParentController:(UIViewController*)theParentController;

-(void)moreInfoButtonPressed;

@end
