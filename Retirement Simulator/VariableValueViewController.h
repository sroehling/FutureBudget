//
//  VariableValueViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VariableValue;
@class TextFieldEditInfo;
@class NumberFieldEditInfo;


@interface VariableValueViewController : UITableViewController {
    @private
        VariableValue *variableValue;
    
        TextFieldEditInfo *nameFieldEditInfo;
        NumberFieldEditInfo *startingValFieldEditInfo;
    
        NSArray *valueChanges;
        UIBarButtonItem *addValueChangeButton;
}

@property(nonatomic,retain) NSArray *valueChanges;
@property(nonatomic,retain) UIBarButtonItem *addValueChangeButton;
@property(nonatomic,retain) VariableValue *variableValue;
@property(nonatomic,retain) TextFieldEditInfo *nameFieldEditInfo;
@property(nonatomic,retain) NumberFieldEditInfo *startingValFieldEditInfo;

- (id)initWithVariableValue:(VariableValue*)theValue;

@end
