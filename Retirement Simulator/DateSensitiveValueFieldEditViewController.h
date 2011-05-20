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

@interface DateSensitiveValueFieldEditViewController : FieldEditTableViewController {
    @private
        DateSensitiveValue *currentValue;
        NSArray *variableValues;
        NSString *variableValueEntityName;
    
}

@property(nonatomic,retain) DateSensitiveValue *currentValue;
@property(nonatomic,retain) NSArray *variableValues;
@property(nonatomic,retain) NSString *variableValueEntityName;

@end
