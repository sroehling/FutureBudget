//
//  PlanListViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/27/13.
//
//

#import <UIKit/UIKit.h>

@interface PlanListViewController : UITableViewController <UIAlertViewDelegate, UITextFieldDelegate>
{
	@private
		NSMutableArray *planNameList;
		NSIndexPath *currentPlanPath;
		
		UIAlertView *renamePlanPrompt;
		NSString *planBeingRenamed;
		
		UIAlertView *addPlanPrompt;
		UIBarButtonItem *addButton;
		
		UIAlertView *deletePlanPrompt;
		NSString *planBeingDeleted;
		
}



@property(nonatomic,retain) NSMutableArray *planNameList;
@property(nonatomic,retain) UIBarButtonItem *addButton;
@property(nonatomic,retain) NSIndexPath *currentPlanPath;

@property(nonatomic,retain) UIAlertView *renamePlanPrompt;
@property(nonatomic,retain) NSString *planBeingRenamed;

@property(nonatomic,retain) UIAlertView *addPlanPrompt;

@property(nonatomic,retain) UIAlertView *deletePlanPrompt;
@property(nonatomic,retain) NSString *planBeingDeleted;

@end
