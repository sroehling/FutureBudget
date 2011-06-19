//
//  VariableHeightTableHeader.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableHeightTableHeader.h"


@implementation VariableHeightTableHeader

@synthesize header;
@synthesize subHeader;

static CGFloat kLeftMargin = 10.0;
static CGFloat kRightMargin = 10.0;
static CGFloat kTopMargin = 4.0;
static CGFloat kBottomMargin = 4.0;
static CGFloat kLabelSpace = 4.0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 150)];
    if (self) {
        // Initialization code
		
		self.header =[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
		self.header.backgroundColor = [UIColor clearColor];
        self.header.opaque = NO;
        self.header.textColor = [UIColor blackColor];
		self.header.textAlignment = UITextAlignmentLeft;
        self.header.highlightedTextColor = [UIColor whiteColor];
        self.header.font = [UIFont boldSystemFontOfSize:14];       
		
		self.subHeader =[[[UILabel alloc] initWithFrame:CGRectZero] autorelease]; 
		self.subHeader.backgroundColor = [UIColor clearColor];
        self.subHeader.opaque = NO;
 		self.subHeader.textAlignment = UITextAlignmentLeft;
		self.subHeader.textColor = [UIColor grayColor];
        self.subHeader.highlightedTextColor = [UIColor whiteColor];
        self.subHeader.font = [UIFont systemFontOfSize:12]; 
		self.subHeader.lineBreakMode = UILineBreakModeWordWrap;
		self.subHeader.numberOfLines = 0;
		
		[self addSubview:self.header];
		[self addSubview:self.subHeader];

    }
    return self;
}

- (CGFloat)subHeaderWidth
{
	CGSize constraintSize =CGSizeMake([UIScreen mainScreen].bounds.size.width-10, MAXFLOAT);
	//CGSize constraintSize =CGSizeMake(self.bounds.size.width, MAXFLOAT);
	//	CGFloat subTitleWidth = [self subTitleWidthWithMargin:overallWidth];

	return constraintSize.width - kLeftMargin - kRightMargin;

}

- (CGFloat)subHeaderHeight
{
	
	CGSize maxSize = CGSizeMake([self subHeaderWidth], 300);
	
	CGSize subHeaderSize = [self.subHeader.text sizeWithFont:self.subHeader.font
			constrainedToSize:maxSize lineBreakMode:self.subHeader.lineBreakMode];
	return subHeaderSize.height;

}

- (void)resizeForChildren
{
	[self.header sizeToFit];  
	[self.subHeader sizeToFit]; 
	CGFloat headerHeight = CGRectGetHeight(self.header.bounds);
	CGFloat subHeaderHeight = [self subHeaderHeight];
	
	CGFloat newHeight = kTopMargin + 
		headerHeight +
		subHeaderHeight + 
		kBottomMargin;
		
	CGRect frame = self.frame;
	frame.size.height = newHeight;
	self.frame = frame;
}

-(void) layoutSubviews {    
	
	[super layoutSubviews];    
	
	// Let the labels size themselves to accommodate their text    
	[self.header sizeToFit];  
	[self.subHeader sizeToFit];    
	
	
	// Position the labels at the top of the table cell    
	CGRect newFrame = self.header.frame;    
	newFrame.origin.x =CGRectGetMinX(self.bounds)+kLeftMargin;
	newFrame.origin.y =CGRectGetMinY(self.bounds)+kTopMargin;
	[self.header setFrame: newFrame];    
	
	
	CGFloat subHeaderX = CGRectGetMinX(self.bounds) + kLeftMargin;
	CGFloat subHeaderY = CGRectGetMaxY(self.header.bounds)+kLabelSpace;
	
	
	[self.subHeader setFrame: CGRectMake(subHeaderX, subHeaderY, [self subHeaderWidth],
						[self subHeaderHeight])];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
