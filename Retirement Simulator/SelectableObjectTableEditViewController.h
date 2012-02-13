//
//  SelectableObjectTableEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GenericFieldBasedTableEditViewController.h"
#import "FormInfoCreator.h"

@class FieldInfo;

@interface SelectableObjectTableEditViewController : GenericFieldBasedTableEditViewController {
    @private
        // Upon selection, the selected value is assigned to assignedField; i.e.
        // the LHS of the assignment
        FieldInfo *assignedField;
        
		// Close (pop view controllers) after selection
		bool closeAfterSelection;
		
		// This is an optiona field/property. When it is
		// set, the controller starts in edit mode with 
		// the given default index. 
		BOOL loadInEditModeIfAssignedFieldNotSet;
}


@property(nonatomic,retain) FieldInfo *assignedField;
@property bool closeAfterSelection;

@property BOOL loadInEditModeIfAssignedFieldNotSet;

-(id)initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator 
            andAssignedField:(FieldInfo*)theAssignedField;

@end
