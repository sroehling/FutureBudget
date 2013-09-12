//
//  ResultsViewInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SimResultsController;

@interface ResultsViewInfo : NSObject {
	@private
		NSString *viewTitle;
}

@property(nonatomic,retain) NSString *viewTitle;

-(id)initWithViewTitle:(NSString*)theViewTitle;

@end
