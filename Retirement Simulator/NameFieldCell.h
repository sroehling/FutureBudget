//
//  NameFieldCell.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldInfo.h"

extern NSString * const NAME_FIELD_CELL_IDENTIFIER;

@interface NameFieldCell : UITableViewCell <UITextFieldDelegate> {
    @private
		UITextField *textField;
		FieldInfo *fieldInfo;
		
}

@property (nonatomic, retain) UITextField *textField;
@property(nonatomic,retain) FieldInfo *fieldInfo;

@end
