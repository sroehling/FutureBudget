//
//  GenericFieldBasedTableAddViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GenericFieldBasedTableViewController.h"


@interface GenericFieldBasedTableAddViewController : GenericFieldBasedTableViewController {
@private
    NSManagedObject *newObject;
    UIBarButtonItem *saveButton;
    NSInteger popDepth;
}

@property(nonatomic,retain) NSManagedObject *newObject;
@property(nonatomic,retain) UIBarButtonItem *saveButton;
@property(nonatomic) NSInteger popDepth;

-(id)initWithFormInfo:(FormInfo*)formInfo andNewObject:(NSManagedObject*)newObj;
- (void)managedObjectsSaved;

@end
