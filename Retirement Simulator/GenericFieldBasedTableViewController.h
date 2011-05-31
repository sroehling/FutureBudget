//
//  GenericFieldBasedTableViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormInfo;

@interface GenericFieldBasedTableViewController : UITableViewController {
    @private
        FormInfo *formInfo;
}

@property(nonatomic,retain) FormInfo *formInfo;

- (id)initWithFormInfo:(FormInfo*)formInfo;

@end
