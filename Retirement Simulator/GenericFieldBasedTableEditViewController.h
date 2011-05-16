//
//  GenericFieldBasedTableEditViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GenericFieldBasedTableEditViewController : UITableViewController <NSFetchedResultsControllerDelegate>{
    @private
        NSMutableArray *fieldEditInfo;
}

@property(nonatomic,retain) NSMutableArray *fieldEditInfo;

-(id)initWithFieldEditInfo:(NSMutableArray *)theFieldEditInfo;

@end
