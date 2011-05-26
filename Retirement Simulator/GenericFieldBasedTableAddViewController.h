//
//  GenericFieldBasedTableAddViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GenericFieldBasedTableAddViewController : UITableViewController {
@private
    NSMutableArray *fieldEditInfo;
    NSManagedObject *newObject;
    UIBarButtonItem *saveButton;
    NSInteger popDepth;
}

@property(nonatomic,retain) NSMutableArray *fieldEditInfo;
@property(nonatomic,retain) NSManagedObject *newObject;
@property(nonatomic,retain) UIBarButtonItem *saveButton;
@property(nonatomic) NSInteger popDepth;

-(id)initWithFieldEditInfo:(NSMutableArray *)theFieldEditInfo andNewObject:(NSManagedObject*)newObj;
- (void)managedObjectsSaved;

@end
