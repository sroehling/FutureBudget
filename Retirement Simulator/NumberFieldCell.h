//
//  NumberFieldCell.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NumberFieldEditInfo;

extern NSString * const NUMBER_FIELD_CELL_ENTITY_NAME;

@interface NumberFieldCell : UITableViewCell <UITextFieldDelegate> {
	UILabel *label;
	UITextField *textField;
    NumberFieldEditInfo *fieldEditInfo;
}

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic,retain) NumberFieldEditInfo *fieldEditInfo;


@end