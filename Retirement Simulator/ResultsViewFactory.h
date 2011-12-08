//
//  ResultsViewFactory.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GenericTableViewFactory.h"

@class ResultsViewInfo;

@interface ResultsViewFactory : NSObject <GenericTableViewFactory> {
	@private
		ResultsViewInfo *resultsViewInfo;
}

@property(nonatomic,retain) ResultsViewInfo *resultsViewInfo;

-(id)initWithResultsViewInfo:(ResultsViewInfo*)theResultsViewInfo;

@end
