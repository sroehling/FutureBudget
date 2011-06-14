//
//  GenericFieldBasedTableEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GenericFieldBasedTableViewController.h"

@interface GenericFieldBasedTableEditViewController : GenericFieldBasedTableViewController {
	@private
		UIBarButtonItem *addButton;
}

@property(nonatomic,retain) UIBarButtonItem *addButton;

@end

@interface UIView(findAndAskForResignationOfFirstResponder)

-(BOOL)findAndAskForResignationOfFirstResponder;

@end