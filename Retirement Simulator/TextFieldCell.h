//
//  TextFieldCell.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldEditInfo;

extern NSString * const TEXT_FIELD_CELL_ENTITY_NAME;

@interface TextFieldCell : UITableViewCell <UITextFieldDelegate> {
	UILabel *label;
	UITextField *textField;
    TextFieldEditInfo *fieldEditInfo;
}

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic,retain) TextFieldEditInfo *fieldEditInfo;


@end
