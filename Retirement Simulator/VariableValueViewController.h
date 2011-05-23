//
//  VariableValueViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VariableValue;


@interface VariableValueViewController : UITableViewController {
    @private
    VariableValue *variableValue;
       NSArray *valueChanges;
        UIBarButtonItem *addValueChangeButton;
}

@property(nonatomic,retain) NSArray *valueChanges;
@property(nonatomic,retain) UIBarButtonItem *addValueChangeButton;
@property(nonatomic,retain) VariableValue *variableValue;

- (id)initWithVariableValue:(VariableValue*)theValue;

@end
