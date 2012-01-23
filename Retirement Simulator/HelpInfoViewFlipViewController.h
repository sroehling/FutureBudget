//
//  HelpInfoViewFlipViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HelpInfoViewControllerDelegate;
@protocol HelpInfoViewDelegate;

@class HelpInfoView;

@interface HelpInfoViewFlipViewController : UIViewController 
{
	@private
		id<HelpInfoViewControllerDelegate> delegate;
		HelpInfoView *helpInfoView;
		id<HelpInfoViewDelegate> helpDoneDelegate;

}

@property(nonatomic,assign) id<HelpInfoViewDelegate> helpDoneDelegate;
@property(nonatomic,retain) HelpInfoView *helpInfoView;

- (id)initWithHelpInfoDoneDelegate:(id<HelpInfoViewDelegate>)helpInfoDoneDel;

@end

