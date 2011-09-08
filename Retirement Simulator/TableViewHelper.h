//
//  TableViewHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TableViewHelper : NSObject {
    
}

+(void)popControllerByDepth:(UIViewController*)currentViewController popDepth:(int)popDepth;

@end
