//
//  TextCaptionWEPopoverContainer.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WEPopoverContainerViewProperties;

@class HelpPagePopoverCaptionInfo;

@interface TextCaptionWEPopoverContainer : UIViewController {
    @private
		HelpPagePopoverCaptionInfo *captionInfo;		
}

@property(nonatomic,retain) HelpPagePopoverCaptionInfo *captionInfo;

- (id)initWithCaptionInfo:(HelpPagePopoverCaptionInfo*)theCaptionInfo;

- (WEPopoverContainerViewProperties *)containerViewProperties;

@end
