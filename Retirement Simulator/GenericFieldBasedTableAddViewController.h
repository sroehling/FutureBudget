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
	
	// The purpose of the disableCoreDataSaveUntilSaveButtonPressed
	// property is in situations where the GenericFieldBasedTableAddViewController
	// is a top-level controller, has it's own DataModelController
	// and all edits & additions made within the view controller or
	// its children should be disabled until validating the new object
	// and pressing the save button.
	BOOL disableCoreDataSaveUntilSaveButtonPressed;
    NSInteger popDepth;
	id<FinishedAddingObjectListener> finishedAddingListener;
}

@property(nonatomic,retain) NSManagedObject *newObject;
@property(nonatomic,retain) UIBarButtonItem *saveButton;
@property(nonatomic,retain) id<FinishedAddingObjectListener> finshedAddingListener;
@property(nonatomic) NSInteger popDepth;
@property BOOL disableCoreDataSaveUntilSaveButtonPressed;

- (id)initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator andNewObject:(NSManagedObject*)newObj
	andDataModelController:(DataModelController*)theDataModelController;

@end
