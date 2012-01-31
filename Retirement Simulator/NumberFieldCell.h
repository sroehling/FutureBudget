//
//  NumberFieldCell.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NumberFieldEditInfo;
@class FieldInfo;
@class NumberFieldValidator;

extern NSString * const NUMBER_FIELD_CELL_ENTITY_NAME;

@interface NumberFieldCell : UITableViewCell <UITextFieldDelegate> {
	UILabel *label;
	UITextField *textField;
	FieldInfo *fieldInfo;
	NumberFieldValidator *validator;
	NSNumberFormatter *numFormatter;
	BOOL disabled;

}

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic,retain) FieldInfo *fieldInfo;
@property (nonatomic,retain) NumberFieldValidator *validator;
@property (nonatomic,retain) NSNumberFormatter *numFormatter;
@property BOOL disabled;

@end