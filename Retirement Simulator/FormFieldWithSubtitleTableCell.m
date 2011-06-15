//
//  FormFieldWithSubtitleTableCell.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormFieldWithSubtitleTableCell.h"
#import "ColorHelper.h"


@implementation FormFieldWithSubtitleTableCell

@synthesize contentDescription;
@synthesize subTitle;
@synthesize caption;


- (id) initWithFrame:(CGRect)frame
{
	self =[super initWithFrame: frame];
	if(self)
	{        
		self.caption =[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
		self.caption.backgroundColor = [UIColor clearColor];
        self.caption.opaque = NO;
        self.caption.textColor = [UIColor blackColor];
		self.caption.textAlignment = UITextAlignmentLeft;
        self.caption.highlightedTextColor = [UIColor whiteColor];
        self.caption.font = [UIFont boldSystemFontOfSize:14];       
		
		[self.contentView addSubview: self.caption];        
		
		self.contentDescription =[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];        
		self.contentDescription.backgroundColor = [UIColor clearColor];
        self.contentDescription.opaque = NO;
        self.contentDescription.textColor = [ColorHelper blueTableTextColor];
		self.contentDescription.textAlignment = UITextAlignmentRight;
        self.contentDescription.highlightedTextColor = [UIColor whiteColor];
        self.contentDescription.font = [UIFont systemFontOfSize:14];       

		[self.contentView addSubview: self.contentDescription];    

		self.subTitle =[[[UILabel alloc] initWithFrame:CGRectZero] autorelease]; 
		self.subTitle.backgroundColor = [UIColor clearColor];
        self.subTitle.opaque = NO;
 		self.subTitle.textAlignment = UITextAlignmentLeft;
		self.subTitle.textColor = [UIColor grayColor];
        self.subTitle.highlightedTextColor = [UIColor whiteColor];
        self.subTitle.font = [UIFont systemFontOfSize:10]; 
		self.subTitle.lineBreakMode = UILineBreakModeWordWrap;
		self.subTitle.numberOfLines = 0;
      
		[self.contentView addSubview: self.subTitle];    


	}    
	return self;
}


static CGFloat kLeftMargin = 10.0;
static CGFloat kRightMargin = 10.0;
static CGFloat kTopMargin = 4.0;
static CGFloat kBottomMargin = 4.0;
static CGFloat kLabelSpace = 4.0;
static CGFloat kDisclosureWidth = 20.0;

- (CGFloat)subTitleWidthWithMargin:(CGFloat)overallWidth
{
	return overallWidth - kLeftMargin - kRightMargin - kDisclosureWidth;
}

- (CGFloat)subTitleHeightForWidth:(CGFloat)overallWidth;
{
	if([self.subTitle.text length] == 0)
	{
		return 0.0;
	}
	else
	{
		CGSize constraintSize =CGSizeMake([UIScreen mainScreen].bounds.size.width-30.0, MAXFLOAT);
		//	CGFloat subTitleWidth = [self subTitleWidthWithMargin:overallWidth];
		CGFloat subTitleWidth = [self subTitleWidthWithMargin:constraintSize.width];
		
		CGSize maxSize = CGSizeMake(subTitleWidth, 300);
		
		CGSize subTitleSize = [self.subTitle.text sizeWithFont:self.subTitle.font
											 constrainedToSize:maxSize
												 lineBreakMode:self.subTitle.lineBreakMode];
		return subTitleSize.height;
		
	}
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	[self.caption sizeToFit];
	CGFloat cellHeight = kTopMargin;
	cellHeight += CGRectGetHeight(self.caption.bounds);
	CGFloat subTitleHeight = [self subTitleHeightForWidth:width];
	if(subTitleHeight > 0.0)
	{
		cellHeight += kLabelSpace;
		cellHeight += subTitleHeight;		
	}
	cellHeight += kBottomMargin;
	return cellHeight;
}

-(void) layoutSubviews {    
 
	[super layoutSubviews];    
   
	// Let the labels size themselves to accommodate their text    
	[caption sizeToFit];    
	[contentDescription sizeToFit];  
	
	
	// Position the labels at the top of the table cell    
	CGRect newFrame = caption.frame;    
	newFrame.origin.x =CGRectGetMinX(self.contentView.bounds)+kLeftMargin;
	newFrame.origin.y =CGRectGetMinY(self.contentView.bounds)+kTopMargin;
	[caption setFrame: newFrame];    
	
	// Put the content description text label immediately to the right         
	// w/10 pixel gap between them    
	newFrame = contentDescription.frame; 
	newFrame.origin.x = CGRectGetMaxX(self.contentView.bounds)-kRightMargin-
		CGRectGetWidth(contentDescription.frame);  
	newFrame.origin.y =CGRectGetMinY(self.contentView.bounds)+kTopMargin;    
	[contentDescription setFrame: newFrame];
	
	CGFloat subTitleX = CGRectGetMinX(self.contentView.bounds) + kLeftMargin;
	CGFloat subTitleY = CGRectGetMaxY(self.caption.bounds)+kLabelSpace;
	
	CGFloat overallSubtitleWidth = CGRectGetWidth(self.contentView.bounds);
	
	[self.subTitle setFrame: CGRectMake(subTitleX, subTitleY, 
				[self subTitleWidthWithMargin:overallSubtitleWidth], 
				[self subTitleHeightForWidth:overallSubtitleWidth])];

}

- (void)dealloc
{
    [super dealloc];
	[contentDescription release];
	[subTitle release];
	[caption release];
}

@end
