//
//  UIHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIHelper.h"
#import "StringValidation.h"

@implementation UIHelper

+(UILabel*)titleForNavBar
{
	UILabel *titleView = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	titleView.backgroundColor = [UIColor clearColor];
	titleView.font = [UIFont boldSystemFontOfSize:17.0];
	titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	titleView.textColor = [UIColor whiteColor]; // Change to desired color
	return titleView;
}

+(void)setCommonBackgroundForTable:(UITableViewController*)theController
{
	theController.tableView.backgroundColor = [UIColor clearColor];
	theController.tableView.backgroundView = [[[UIImageView alloc] 
			initWithImage:[UIImage imageNamed:@"textureOldPaperSmall.png"]] autorelease];
}


// This purpose of this  method is to shrink the font size displayed in the title from
// the standard of 20 to 17. This allows more of the title to be shown, and also shows
// the title in a more comparable proportion with the other fonts in the table view.
+(void)setCommonTitleForTable:(UITableViewController*)theController withTitle:(NSString*)title
{
	assert(theController != nil);
	assert([StringValidation nonEmptyString:title]);
    UILabel *titleView = (UILabel *)theController.navigationItem.titleView;
    if (!titleView) {
		titleView = [UIHelper titleForNavBar];
        theController.navigationItem.titleView = titleView;
     }
    titleView.text = title;
    [titleView sizeToFit];

}


+ (UIImage*)stretchableButtonImage:(NSString*)imageFileName
{
	UIImage *image = [UIImage imageNamed:imageFileName];
	UIImage *strechableImage = 
			[image stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	return strechableImage;
}

+ (UIButton*)imageButton:(NSString*)imgFilePrefix
{
	UIButton *theButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	theButton.backgroundColor = [UIColor clearColor];
	
	NSString *normalFileName = [NSString stringWithFormat:
		@"%@.png",imgFilePrefix];
	[theButton setBackgroundImage:[UIHelper stretchableButtonImage:normalFileName] 
		forState:UIControlStateNormal];
		
	NSString *highlightFileName = [NSString stringWithFormat:
		@"%@-1.png",imgFilePrefix];
	[theButton setBackgroundImage:[UIHelper stretchableButtonImage:highlightFileName] forState:UIControlStateHighlighted];
	
	return theButton;
	
}


@end
