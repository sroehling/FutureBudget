//
//  InputTypeSelectionViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InputTypeSelectionViewController : UITableViewController {
    @private
        NSMutableArray *inputTypes;
        BOOL typeSelected;
}

@property(nonatomic,retain) NSMutableArray *inputTypes;

@end
