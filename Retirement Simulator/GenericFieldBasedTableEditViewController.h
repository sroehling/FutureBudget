//
//  GenericFieldBasedTableEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GenericFieldBasedTableViewController.h"
#import "TextCaptionWEPopoverContainer.h"

@class WEPopoverController;

@interface GenericFieldBasedTableEditViewController : GenericFieldBasedTableViewController {
	@private
		UIBarButtonItem *addButton;
		WEPopoverController *addButtonPopoverController;
}

@property(nonatomic,retain) UIBarButtonItem *addButton;
@property(nonatomic,retain) WEPopoverController *addButtonPopoverController;

@end

