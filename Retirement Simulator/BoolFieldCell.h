//
//  BoolFieldCell.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FieldInfo;

@interface BoolFieldCell : UITableViewCell  {
	UILabel *label;
	UISwitch *boolSwitch;
	FieldInfo *boolFieldInfo;

}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UISwitch *boolSwitch;
@property (nonatomic,retain) FieldInfo *boolFieldInfo;

@end
