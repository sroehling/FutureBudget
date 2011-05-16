//
//  TextFieldEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FieldEditViewController.h"

@interface TextFieldEditViewController : FieldEditViewController {

	UITextField *textField;	
}

@property (nonatomic, retain) IBOutlet UITextField *textField;


@end
