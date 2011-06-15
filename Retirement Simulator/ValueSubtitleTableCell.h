//
//  ValueSubtitleTableCell.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ValueSubtitleTableCell : UITableViewCell {
	@private
		UILabel *caption;
		UILabel *valueDescription;
		UILabel *valueSubtitle;
}

@property(nonatomic,retain) UILabel *caption;
@property(nonatomic,retain) UILabel *valueDescription;
@property(nonatomic,retain) UILabel *valueSubtitle;

- (CGFloat)cellHeight;    


@end
