//
//  BoolFieldCell.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FieldInfo;

extern NSString * const BOOL_FIELD_CELL_ENTITY_NAME;

@interface BoolFieldCell : UITableViewCell  {
	UILabel *label;
	UISwitch *boolSwitch;
	FieldInfo *boolFieldInfo;

}

@property(nonatomic,retain) UILabel *label;
@property(nonatomic,retain) UISwitch *boolSwitch;
@property (nonatomic,retain) FieldInfo *boolFieldInfo;


@end
