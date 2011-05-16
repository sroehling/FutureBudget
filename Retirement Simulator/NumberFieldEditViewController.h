//
//  NumberFieldEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FieldEditViewController.h"

@interface NumberFieldEditViewController : FieldEditViewController {
	UITextField *textField;
    NSNumberFormatter *numberFormatter;
	
}

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) NSNumberFormatter *numberFormatter;

@end
