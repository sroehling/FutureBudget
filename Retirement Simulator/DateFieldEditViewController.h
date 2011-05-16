//
//  DateFieldEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldEditViewController.h"

@interface DateFieldEditViewController : FieldEditViewController {
	UIDatePicker *datePicker;
}

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

@end
