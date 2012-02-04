//
//  UIHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIHelper : NSObject {
    
}

+(UILabel*)titleForNavBar;
+(void)setCommonBackgroundForTable:(UITableViewController*)theController;
+(void)setCommonTitleForTable:(UITableViewController*)theController withTitle:(NSString*)title;

+ (UIImage*)stretchableButtonImage:(NSString*)imageFileName;
+ (UIButton*)imageButton:(NSString*)imgFilePrefix;

+ (CGFloat)labelHeight:(UILabel*)theLabel forWidth:(CGFloat)maxWidth 
	andLeftMargin:(CGFloat)leftMargin
	andRightMargin:(CGFloat)rightMargin;

@end


@interface UIView(findAndAskForResignationOfFirstResponder)

-(BOOL)findAndAskForResignationOfFirstResponder;

@end
