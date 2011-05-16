//
//  RepeatFrequencyEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FieldEditTableViewController.h"
#import "EventRepeatFrequency.h"

@interface RepeatFrequencyEditViewController : FieldEditTableViewController {
@private
    NSArray *repeatFrequencies;
    EventRepeatFrequency *currentFrequency;
}

@property (nonatomic, retain) NSArray *repeatFrequencies;
@property(nonatomic,retain) EventRepeatFrequency *currentFrequency;

@end
