//
//  HelpInfoView.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HelpInfoViewDelegate;

@interface HelpInfoView : UIView {
	@private
		UIWebView *helpInfo;
		UINavigationBar *navBar;
		UILabel *navBarTitle;
		id<HelpInfoViewDelegate> helpInfoViewDelegate;   
}

@property(nonatomic,retain) UIWebView *helpInfo;
@property(nonatomic,retain) UINavigationBar *navBar;
@property(nonatomic,assign) id<HelpInfoViewDelegate> helpInfoViewDelegate;
@property(nonatomic,retain)  UILabel *navBarTitle;

@end

@protocol HelpInfoViewDelegate
-(void)helpInfoViewDone;
-(NSString*)helpInfoHTML;
-(NSString*)helpTitle;
@end
