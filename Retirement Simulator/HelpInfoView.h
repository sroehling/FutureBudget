//
//  HelpInfoView.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HelpFlipViewInfo;

@interface HelpInfoView : UIView {
	@private
		UIWebView *helpInfo;
		UINavigationBar *navBar;
		UILabel *navBarTitle;
		HelpFlipViewInfo *helpFlipViewInfo;
		
}

@property(nonatomic,retain) UIWebView *helpInfo;
@property(nonatomic,retain) UINavigationBar *navBar;
@property(nonatomic,retain) HelpFlipViewInfo *helpFlipViewInfo;
@property(nonatomic,retain)  UILabel *navBarTitle;

@end
