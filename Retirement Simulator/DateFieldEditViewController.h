//
//  DateFieldEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DateFieldEditViewController : UIViewController {
    NSManagedObject *editedObject;
    NSString *editedFieldKey;
    NSString *editedFieldName;
	
	UIDatePicker *datePicker;

}

@property (nonatomic, retain) NSManagedObject *editedObject;
@property (nonatomic, retain) NSString *editedFieldKey;
@property (nonatomic, retain) NSString *editedFieldName;

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

- (IBAction)cancel;
- (IBAction)save;

@end
