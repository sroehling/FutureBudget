//
//  TableCellHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableCellHelper.h"
#import "ColorHelper.h"


@implementation TableCellHelper

+(UILabel*)createLabel
{
	UILabel *label =[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.opaque = NO;
	label.textColor = [UIColor blackColor];
	label.textAlignment = UITextAlignmentLeft;
	label.highlightedTextColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:TABLE_CELL_LABEL_FONT_SIZE];       
	return label;
}

+(UILabel*)createNonEditableBlueValueLabel
{ 
	UILabel *valueLabel =[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];        
	valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.opaque = NO;
    valueLabel.textColor = [ColorHelper blueTableTextColor];
	valueLabel.textAlignment = UITextAlignmentRight;
    valueLabel.highlightedTextColor = [UIColor whiteColor];
    valueLabel.font = [UIFont systemFontOfSize:14];       
	return valueLabel;
}

+(UILabel*)createSubtitleLabel
{
	UILabel *subtitleLabel =[[[UILabel alloc] initWithFrame:CGRectZero] autorelease]; 
	subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.opaque = NO;
 	subtitleLabel.textAlignment = UITextAlignmentLeft;
	subtitleLabel.textColor = [UIColor grayColor];
    subtitleLabel.highlightedTextColor = [UIColor whiteColor];
    subtitleLabel.font = [UIFont systemFontOfSize:10]; 
	return subtitleLabel;
}

+(UILabel*)createWrappedSubtitleLabel
{
	UILabel *subtitleLabel = [TableCellHelper createSubtitleLabel];
	subtitleLabel.lineBreakMode = UILineBreakModeWordWrap;
	subtitleLabel.numberOfLines = 0;
	return subtitleLabel;
}



+(UITextField*)createTextField
{
	UITextField *textField =[[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
	textField.backgroundColor = [UIColor clearColor];
	textField.opaque = NO;
	textField.textColor = [UIColor blackColor];
	textField.textAlignment = UITextAlignmentRight;
	textField.font = [UIFont systemFontOfSize:TABLE_CELL_LABEL_FONT_SIZE];       
	return textField;
}

+(UITextField*)createTitleTextField
{
	UITextField *textField = [TableCellHelper createTextField];
	textField.font = [UIFont boldSystemFontOfSize:TABLE_CELL_LABEL_FONT_SIZE];
	textField.textAlignment = UITextAlignmentCenter;
	return textField;
}

+(UISwitch*)createSwitch
{
	UISwitch *theSwitch =[[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];        
	theSwitch.backgroundColor = [UIColor clearColor];
	theSwitch.opaque = NO;
	return theSwitch;
}

+(void)topLeftAlignChild:(UIView*)theChild withinParentFrame:(CGRect)parentFrame
{
	assert(theChild != nil);
	CGRect newFrame = theChild.frame;    
	newFrame.origin.x =CGRectGetMinX(parentFrame)+TABLE_CELL_LEFT_MARGIN;
	newFrame.origin.y =CGRectGetMinY(parentFrame)+TABLE_CELL_TOP_MARGIN;
	[theChild setFrame: newFrame];    

}

+(void)topRightAlignChild:(UIView*)theChild  withinParentFrame:(CGRect)parentFrame
{
	CGRect newFrame = theChild.frame; 
	newFrame.origin.x = CGRectGetMaxX(parentFrame)-TABLE_CELL_RIGHT_MARGIN-
		CGRectGetWidth(theChild.frame);  
	newFrame.origin.y =CGRectGetMinY(parentFrame)+TABLE_CELL_TOP_MARGIN;    
	[theChild setFrame:newFrame];
}

+(void)sizeChildWidthToFillParent:(UIView*)theChild withinParentFrame:(CGRect)parentFrame
{
	CGRect newFrame = theChild.frame;
	newFrame.size.width = CGRectGetWidth(parentFrame) - TABLE_CELL_RIGHT_MARGIN - TABLE_CELL_LEFT_MARGIN;
	[theChild setFrame:newFrame];
}

+(void)enableTextFieldEditing:(UITextField*)textField andEditing:(BOOL)isEditing
{	
    textField.enabled = isEditing;
    if(isEditing)
    {
  //       textField.borderStyle = UITextBorderStyleBezel;
         textField.borderStyle = UITextBorderStyleLine;
   }
    else
    {
        textField.borderStyle = UITextBorderStyleNone;
    }
	
	// When using the different border style in edit mode, the height of the text field needs to change
	// to accommodate the bezel and input cursor. The code below adjusts the height
	// of the UITextField without adjusting any other size parameters.
	CGRect currentSize = textField.frame;
	[textField sizeToFit];
	CGRect newSize = textField.frame;
	currentSize.size.height = newSize.size.height;
	[textField setFrame:currentSize];

}


@end
