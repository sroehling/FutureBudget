//
//  SelectableObjectTableEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GenericFieldBasedTableEditViewController.h"
#import "ManagedObjectFieldInfo.h"
#import "FormInfoCreator.h"

@interface SelectableObjectTableEditViewController : GenericFieldBasedTableEditViewController {
    @private
        // Upon selection, the selected value is assigned to assignedField; i.e.
        // the LHS of the assignment
        ManagedObjectFieldInfo *assignedField;
    
        // formInfoCreator is used to initially populate, then repopulate the 
        // view as needed.
        id<FormInfoCreator> formInfoCreator;
    
        // The currently selected value, serves as the RHS of the assignement
        NSManagedObject *currentValue;
    
        NSIndexPath *currentValueIndex;
}


@property(nonatomic,retain) ManagedObjectFieldInfo *assignedField;
@property(nonatomic,retain) id<FormInfoCreator> formInfoCreator;
@property(nonatomic,retain) NSManagedObject *currentValue;
@property(nonatomic,retain) NSIndexPath *currentValueIndex;

-(id)initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator 
            andAssignedField:(ManagedObjectFieldInfo*)theAssignedField;

@end
