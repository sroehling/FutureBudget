//
//  FieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FieldEditInfo <NSObject>

- (NSString*)textLabel;
- (NSString*)detailTextLabel;

- (BOOL)hasFieldEditController;
- (UIViewController*)fieldEditController;

- (UITableViewCell*)cellForFieldEdit:(UITableView*)tableView;

@end
