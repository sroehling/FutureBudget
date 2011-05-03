//
//  OneTimeExpenseViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OneTimeExpenseInput;

@interface OneTimeExpenseViewController : UITableViewController {
    OneTimeExpenseInput *expense;
    NSDateFormatter *dateFormatter;
    NSNumberFormatter *numberFormatter;
}

@property (nonatomic, retain) OneTimeExpenseInput *expense;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSNumberFormatter *numberFormatter;

@end
