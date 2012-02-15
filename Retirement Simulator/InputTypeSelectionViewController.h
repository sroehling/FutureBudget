//
//  InputTypeSelectionViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModelController;


@interface InputTypeSelectionViewController : UITableViewController {
    @private
        NSMutableArray *inputTypes;
        BOOL typeSelected;
		DataModelController *dmcForNewInputs;
}

@property(nonatomic,retain) NSMutableArray *inputTypes;
@property(nonatomic,retain) DataModelController *dmcForNewInputs;

@end
