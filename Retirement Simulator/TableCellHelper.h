//
//  TableCellHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TABLE_CELL_RIGHT_MARGIN 10.0
#define TABLE_CELL_LEFT_MARGIN 10.0
#define TABLE_CELL_TOP_MARGIN 5.0
#define TABLE_CELL_BOTTOM_MARGIN 5.0
#define TABLE_CELL_CHILD_SPACE 2.0
#define TABLE_CELL_MIN_OVERALL_HEIGHT_TO_SUPPORT_DELETE 40.0
#define TABLE_CELL_LABEL_FONT_SIZE 14

#define TABLE_CELL_DISCLOSURE_WIDTH 20.0

@interface TableCellHelper : NSObject {
    
}

+(UILabel*)createLabel;
+(UILabel*)createNonEditableBlueValueLabel;
+(UILabel*)createSubtitleLabel;
+(UILabel*)createWrappedSubtitleLabel;

+(UITextField*)createTextField;
+(UITextField*)createTitleTextField;
+(UISwitch*)createSwitch;

+(void)enableTextFieldEditing:(UITextField*)textField andEditing:(BOOL)isEditing;

+(void)sizeChildWidthToFillParent:(UIView*)theChild withinParentFrame:(CGRect)parentFrame;

+(void)topLeftAlignChild:(UIView*)theChild withinParentFrame:(CGRect)parentFrame;
+(void)topRightAlignChild:(UIView*)theChild withinParentFrame:(CGRect)parentFrame;


@end
