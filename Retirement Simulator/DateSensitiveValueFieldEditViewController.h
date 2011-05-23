//
//  DateSensitiveValueFieldEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldEditTableViewController.h"
@class DateSensitiveValue;
@class ManagedObjectFieldInfo;
@class FixedValue;

@interface DateSensitiveValueFieldEditViewController : UITableViewController {
    @private
        DateSensitiveValue *currentValue;
        FixedValue *currentFixedValue;
        NSArray *variableValues;
        ManagedObjectFieldInfo *fieldInfo;
        NSNumberFormatter *numberFormatter;
        NSString *variableValueEntityName;
        UIBarButtonItem *addVariableValueButton;
        BOOL viewPushed;
        
    
}

- (id) initWithFieldInfo:(ManagedObjectFieldInfo*)theFieldInfo;
- (IBAction)addVariableValue;

@property(nonatomic,retain) DateSensitiveValue *currentValue;
@property(nonatomic,retain) FixedValue *currentFixedValue;
@property(nonatomic,retain) NSArray *variableValues;
@property(nonatomic,retain) NSString *variableValueEntityName;
@property(nonatomic,retain) ManagedObjectFieldInfo *fieldInfo;
@property(nonatomic,retain) UIBarButtonItem *addVariableValueButton;

@property (nonatomic, retain) NSNumberFormatter *numberFormatter;

@end
