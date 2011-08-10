//
//  RelativeDatePickerViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FieldInfo;
@class RelativeEndDateInfo;

@interface RelativeDatePickerViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate> {

	UIPickerView *relDatePicker;
	FieldInfo *relEndDateFieldInfo;
	RelativeEndDateInfo *relEndDateInfo;
    
}

- (id)initWithRelativeEndDateFieldInfo:(FieldInfo*)theRelEndDateFieldInfo;

@property(nonatomic,retain) UIPickerView *relDatePicker;
@property(nonatomic,retain) FieldInfo *relEndDateFieldInfo;
@property(nonatomic,retain) RelativeEndDateInfo *relEndDateInfo;

@end
