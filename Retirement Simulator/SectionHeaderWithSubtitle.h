//
//  SectionHeaderWithSubtitle.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderAddButtonDelegate.h"
#import "HelpInfoView.h"

@interface SectionHeaderWithSubtitle : UIView {
    @private
		UILabel *headerLabel;
		NSString *helpInfoHTMLFile;
		CGFloat subtitleHeight;
		UIButton *infoButton;
		
		UIButton *addButton;
		id<SectionHeaderAddButtonDelegate> addButtonDelegate;
		UIViewController *parentController;
}

@property(nonatomic,retain) UILabel *headerLabel;
@property(nonatomic,retain) NSString *helpInfoHTMLFile;
@property(nonatomic,retain) UIButton *infoButton;
@property(nonatomic,retain) UIButton *addButton;
@property(nonatomic,retain) id<SectionHeaderAddButtonDelegate> addButtonDelegate;
@property(nonatomic,assign) UIViewController *parentController;

-(void)sizeForTableWidth:(CGFloat)tableWidth andEditMode:(BOOL)editing;
-(CGFloat)headerHeight;


@end
