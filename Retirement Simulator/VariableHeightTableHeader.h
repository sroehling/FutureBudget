//
//  VariableHeightTableHeader.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VariableHeightTableHeader : UIView {
    @private
		UILabel *header;
		UILabel *subHeader;
}

@property(nonatomic,retain) UILabel *header;
@property(nonatomic,retain) UILabel *subHeader;

- (void)resizeForChildren;

@end
