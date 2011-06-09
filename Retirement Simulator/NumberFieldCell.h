//
//  NumberFieldCell.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NumberFieldEditInfo;

@interface NumberFieldCell : UITableViewCell {
	UILabel *label;
	UITextField *textField;
    NumberFieldEditInfo *fieldEditInfo;
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic,retain) NumberFieldEditInfo *fieldEditInfo;


@end