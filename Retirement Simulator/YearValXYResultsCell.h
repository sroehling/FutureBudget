//
//  YearValXYResultsCell.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat YEARVAL_RESULTS_CELL_YEAR_LEFT_OFFSET;
extern const CGFloat YEARVAL_RESULTS_CELL_VALUE_LEFT_OFFSET;
extern const CGFloat YEARVAL_RESULTS_CELL_COLUMN_WIDTH;
extern const CGFloat YEARVAL_RESULTS_CELL_HEIGHT;

@interface YearValXYResultsCell : UITableViewCell
{
	@private
		UILabel *year;
		UILabel *value;
}

@property(nonatomic,retain) UILabel *year;
@property(nonatomic,retain) UILabel *value;

@end
