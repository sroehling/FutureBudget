//
//  HelpPageViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HelpPageInfo;

@interface HelpPageViewController : UIViewController {
    @private
		HelpPageInfo *helpPageInfo;
		UIWebView *helpPage;
}

-(id)initWithHelpPageInfo:(HelpPageInfo*)theHelpPageInfo;

@property(nonatomic,retain) HelpPageInfo *helpPageInfo;
@property(nonatomic,retain) UIWebView *helpPage;

@end
