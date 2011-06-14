//
//  FormFieldWithSubtitleTableCell.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FormFieldWithSubtitleTableCell : UITableViewCell {
    @private
		UILabel *caption;
		UILabel *contentDescription;
		UILabel *subTitle;
}

@property(nonatomic,retain) UILabel *caption;
@property(nonatomic,retain) UILabel *contentDescription;
@property(nonatomic,retain) UILabel *subTitle;

- (CGFloat)cellHeightForWidth:(CGFloat)width;

@end
