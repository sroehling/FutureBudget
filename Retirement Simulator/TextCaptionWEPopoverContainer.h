//
//  TextCaptionWEPopoverContainer.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WEPopoverContainerViewProperties;

@interface TextCaptionWEPopoverContainer : UIViewController {
    @private
		NSString* captionText;
}

@property(nonatomic,retain) NSString *captionText;

- (id)initWithCaption:(NSString*)theCaptionText ;
- (WEPopoverContainerViewProperties *)containerViewProperties;

@end
