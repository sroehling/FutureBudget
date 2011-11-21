//
//  StaticNameFieldCell.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const STATIC_NAME_FIELD_CELL_IDENTIFIER;

@interface StaticNameFieldCell : UITableViewCell {
	@private
		UILabel *staticName;
}

@property(nonatomic,retain) UILabel *staticName;

@end
