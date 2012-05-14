//
//  YearValXYResultsCell.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YearValXYResultsCell.h"
#import "TableCellHelper.h"

const CGFloat YEARVAL_RESULTS_CELL_YEAR_LEFT_OFFSET = 10.0;
const CGFloat YEARVAL_RESULTS_CELL_VALUE_LEFT_OFFSET = 170.0;
const CGFloat YEARVAL_RESULTS_CELL_COLUMN_WIDTH = 150.0;
const CGFloat YEARVAL_RESULTS_CELL_HEIGHT = 28.0;


@implementation YearValXYResultsCell

@synthesize year;
@synthesize value;

- (id) initWithFrame:(CGRect)frame
{
	self =[super initWithFrame: frame];
	if(self)
	{        
		self.year = [TableCellHelper createValueLabel];       
		[self.contentView addSubview: self.year];        

		self.value = [TableCellHelper createValueLabel];       
		[self.contentView addSubview: self.value];		        
				
		self.editingAccessoryType = UITableViewCellAccessoryNone;
		self.accessoryType = UITableViewCellAccessoryNone;
	}    
	return self;
}

-(void) layoutSubviews {    
	
	[super layoutSubviews];    

	// Let the labels size themselves to accommodate their text    
	[value sizeToFit];
	
	
	[TableCellHelper topRightAlignChild:value withinParentFrame:self.contentView.bounds];
	
	[year setFrame:CGRectMake(YEARVAL_RESULTS_CELL_YEAR_LEFT_OFFSET, 0, 
			YEARVAL_RESULTS_CELL_COLUMN_WIDTH, YEARVAL_RESULTS_CELL_HEIGHT)];
	year.textAlignment = UITextAlignmentCenter;
	
	[value setFrame:CGRectMake(YEARVAL_RESULTS_CELL_VALUE_LEFT_OFFSET, 0, 
			100.0, YEARVAL_RESULTS_CELL_HEIGHT)];
	value.textAlignment = UITextAlignmentRight;
	
		
}

- (void)dealloc
{
	[year release];
	[value release];
    [super dealloc];
}

@end
