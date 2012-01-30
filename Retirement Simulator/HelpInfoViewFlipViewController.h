//
//  HelpInfoViewFlipViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HelpInfoViewControllerDelegate;
@class HelpFlipViewInfo;

@class HelpInfoView;

@interface HelpInfoViewFlipViewController : UIViewController 
{
	@private
		id<HelpInfoViewControllerDelegate> delegate;
		HelpInfoView *helpInfoView;
		HelpFlipViewInfo *helpFlipViewInfo;

}

- (id)initWithHelpFlipViewInfo:(HelpFlipViewInfo*)theHelpFlipViewInfo;

@property(nonatomic,retain) HelpFlipViewInfo *helpFlipViewInfo;
@property(nonatomic,retain) HelpInfoView *helpInfoView;


@end

