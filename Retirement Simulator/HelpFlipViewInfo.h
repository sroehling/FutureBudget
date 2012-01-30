//
//  HelpFlipViewInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HelpFlipViewInfo : NSObject {
	@private
		UIViewController *parentController;
		NSString *title;
		NSString *helpPageHTMLFile;
}

-(id)initWithParentController:(UIViewController*)theParentController
	andTitle:(NSString*)theTitle
	andHelpPageHTMLFile:(NSString*)helpHTML;

@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *helpPageHTMLFile;
@property(nonatomic,assign) UIViewController *parentController;


@end
