//
//  UIHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIHelper : NSObject {
    
}

+(UILabel*)titleForNavBar;
+(void)setCommonBackgroundForTable:(UITableViewController*)theController;
+(void)setCommonTitleForTable:(UITableViewController*)theController withTitle:(NSString*)title;

@end
