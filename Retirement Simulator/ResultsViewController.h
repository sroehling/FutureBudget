//
//  ResultsViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ResultsViewInfo;

@interface ResultsViewController : UIViewController{
	@private
		ResultsViewInfo *viewInfo;
}

@property(nonatomic,retain) ResultsViewInfo *viewInfo;;

-(id)initWithResultsViewInfo:(ResultsViewInfo*)theViewInfo;

@end
