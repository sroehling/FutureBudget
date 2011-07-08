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
    
        // The currently selected value, serves as the RHS of the assignement
        NSManagedObject *currentValue;
    
        NSIndexPath *currentValueIndex;
}


@property(nonatomic,retain) FieldInfo *assignedField;
@property(nonatomic,retain) NSManagedObject *currentValue;
@property(nonatomic,retain) NSIndexPath *currentValueIndex;

-(id)initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator 
            andAssignedField:(FieldInfo*)theAssignedField;

@end
