//
//  DurationFieldEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FieldInfo;

@interface DurationFieldEditViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate> {
    @private
		UIPickerView *durationPicker;
		FieldInfo *durationFieldInfo;
}

- (id)initWithDurationFieldInfo:(FieldInfo*)theFieldInfo;

@property(nonatomic,retain) FieldInfo *durationFieldInfo;
@property(nonatomic,retain) UIPickerView *durationPicker;

@end
