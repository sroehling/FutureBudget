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
		SimResultsController *simResultsController;
		NSString *viewTitle;
}

@property(nonatomic,retain) SimResultsController *simResultsController;
@property(nonatomic,retain) NSString *viewTitle;

-(id)initWithSimResultsController:(SimResultsController*)theSimResultsController
	andViewTitle:(NSString*)theViewTitle;

@end
