//
//  GenericFieldBasedTableAddViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GenericFieldBasedTableViewController.h"
#import "FormInfoCreator.h"
#import "FinishedAddingObjectListener.h"

@class DataModelController;

@interface GenericFieldBasedTableAddViewController : GenericFieldBasedTableViewController {
@private
    NSManagedObject *newObject;
    UIBarButtonItem *saveButton;
    NSInteger popDepth;
	id<FinishedAddingObjectListener> finishedAddingListener;
}

@property(nonatomic,retain) NSManagedObject *newObject;
@property(nonatomic,retain) UIBarButtonItem *saveButton;
@property(nonatomic,retain) id<FinishedAddingObjectListener> finshedAddingListener;
@property(nonatomic) NSInteger popDepth;

- (id)initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator andNewObject:(NSManagedObject*)newObj
	andDataModelController:(DataModelController*)theDataModelController;

@end
