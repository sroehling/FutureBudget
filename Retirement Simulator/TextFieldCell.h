//
//  TextFieldCell.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldEditInfo;


@interface TextFieldCell : UITableViewCell {
	UILabel *label;
	UITextField *textField;
    TextFieldEditInfo *fieldEditInfo;
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic,retain) TextFieldEditInfo *fieldEditInfo;


@end
