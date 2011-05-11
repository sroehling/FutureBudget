//
//  RepeatFrequencyEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OneTimeExpenseInput;

@interface RepeatFrequencyEditViewController : UITableViewController {
@private
    OneTimeExpenseInput *expenseInput;
    NSArray *repeatFrequencies;
}

@property (nonatomic, retain) OneTimeExpenseInput *expenseInput;
@property (nonatomic, retain) NSArray *repeatFrequencies;

@end
