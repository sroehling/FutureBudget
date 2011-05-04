//
//  NumberFieldEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NumberFieldEditViewController : UIViewController {
	UITextField *textField;
    
    NSManagedObject *editedObject;
    NSString *editedFieldKey;
    NSString *editedFieldName;
    
    NSNumberFormatter *numberFormatter;
	
}

@property (nonatomic, retain) IBOutlet UITextField *textField;

@property (nonatomic, retain) NSManagedObject *editedObject;
@property (nonatomic, retain) NSString *editedFieldKey;
@property (nonatomic, retain) NSString *editedFieldName;
@property (nonatomic, retain) NSNumberFormatter *numberFormatter;

- (IBAction)cancel;
- (IBAction)save;

@end
