//
//  HelpViewFactory.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GenericTableViewFactory.h"

@class HelpPageInfo;

@interface HelpViewFactory : NSObject <GenericTableViewFactory> {
    @private
		HelpPageInfo *helpPageInfo;
}

@property(nonatomic,retain) HelpPageInfo *helpPageInfo;
	
-(id)initWithHelpPageInfo:(HelpPageInfo*)theHelpPageInfo;



@end
