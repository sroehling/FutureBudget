//
//  GenericFieldBasedTableViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormInfo;
@class DataModelController;

#import "FormInfoCreator.h"

@interface GenericFieldBasedTableViewController : UITableViewController {
    @private
        FormInfo *formInfo;
    
        // formInfoCreator is used to initially populate, then repopulate the 
        // view as needed.
        id<FormInfoCreator> formInfoCreator;
		
		// The DataModelController for savings new/changed objects
		DataModelController *dataModelController;
		
		// The following 2 member variables
		// track section updates when entering
		// or exiting edit mode.
		BOOL enteringEditMode;
		BOOL enteringEditModeEditing;
}

@property(nonatomic,retain) FormInfo *formInfo;
@property(nonatomic,retain) id<FormInfoCreator> formInfoCreator;
@property(nonatomic,retain) DataModelController *dataModelController;

-(id)initWithFormInfoCreator:(id<FormInfoCreator>) theFormInfoCreator
	andDataModelController:(DataModelController*)theDataModelController; 
- (void)selectAndOpenFieldEditInfoForIndex:(NSIndexPath *)indexPath;       


@end
