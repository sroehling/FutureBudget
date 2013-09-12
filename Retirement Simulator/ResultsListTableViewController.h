//
//  ResultsListTableViewController.h
//  FutureBudget
//
//  Created by Steve Roehling on 9/11/13.
//
//

#import "GenericFieldBasedTableViewController.h"

@class MBProgressHUD;

@interface ResultsListTableViewController : GenericFieldBasedTableViewController {
    @private
        MBProgressHUD *simProgressHUD;
}

@property(nonatomic,retain) MBProgressHUD *simProgressHUD;


@end
