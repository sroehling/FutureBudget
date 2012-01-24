//
//  HelpPageInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HelpPageInfo : NSObject {
	@private
		UIViewController *parentController;
		NSString *helpPageHTML;
}

-(id)initWithParentController:(UIViewController*)theParentController
	andHelpPageHTML:(NSString*)helpHTML;

@property(nonatomic,retain) NSString *helpPageHTML;
@property(nonatomic,assign) UIViewController *parentController;

@end