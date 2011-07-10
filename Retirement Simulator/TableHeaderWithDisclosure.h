//
//  TableHeaderWithDisclosure.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TableHeaderDisclosureButtonDelegate.h"

@interface TableHeaderWithDisclosure : UIView {
    @private
		UILabel *header;
		UIButton *disclosureButton;
		id<TableHeaderDisclosureButtonDelegate> disclosureButtonDelegate;
}

@property(nonatomic,retain) UILabel *header;
@property(nonatomic,retain) UIButton *disclosureButton;
@property(nonatomic,retain) id<TableHeaderDisclosureButtonDelegate> disclosureButtonDelegate;

- (id)initWithFrame:(CGRect)frame 
	andDisclosureButtonDelegate:(id<TableHeaderDisclosureButtonDelegate>)delegate;

- (void)resizeForChildren;

@end
