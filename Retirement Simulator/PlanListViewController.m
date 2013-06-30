//
//  PlanListViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/27/13.
//
//

#import "PlanListViewController.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "LocalizationHelper.h"
#import "UIHelper.h"
#import "TableHeaderWithHelpFlipView.h"

NSUInteger const MAX_PLAN_NAME_LENGTH = 32;

@implementation PlanListViewController

@synthesize planNameList;
@synthesize addButton;
@synthesize currentPlanPath;
@synthesize renamePlanPrompt;
@synthesize addPlanPrompt;
@synthesize deletePlanPrompt;
@synthesize planBeingRenamed;
@synthesize planBeingDeleted;

-(void)dealloc
{
	[planNameList release];
	[addButton release];
	[currentPlanPath release];
	
	[addPlanPrompt release];
	[renamePlanPrompt release];
	[planBeingRenamed release];
	
	[deletePlanPrompt release];
	[planBeingDeleted release];
	
	[super dealloc];
}

-(UIAlertView*)planNameAlertViewWithTitle:(NSString*)alertTitle andMessage:(NSString*)alertMsg
{
	UIAlertView *planNameAlertView = [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMsg
		delegate:self cancelButtonTitle:LOCALIZED_STR(@"CANCEL_PLAN_NAME_BUTTON_TITLE")
				otherButtonTitles:LOCALIZED_STR(@"CONFIRM_PLAN_NAME_BUTTON_TITLE"), nil] autorelease];

	planNameAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	planNameAlertView.delegate = self;


	UITextField *planNameTextField = [planNameAlertView textFieldAtIndex:0];
	planNameTextField.delegate = self;
	planNameTextField.placeholder = LOCALIZED_STR(@"PLAN_NAME_PLACEHOLDER");
	planNameTextField.text = @"";
		
	
	return planNameAlertView;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		
		self.addPlanPrompt = [self planNameAlertViewWithTitle:LOCALIZED_STR(@"NEW_PLAN_PROMPT_TITLE")
					andMessage:LOCALIZED_STR(@"PLAN_NAME_PROMPT_MESSAGE")];
		self.renamePlanPrompt = [self planNameAlertViewWithTitle:LOCALIZED_STR(@"RENAME_PLAN_PROMPT_TITLE")
			andMessage:LOCALIZED_STR(@"PLAN_NAME_PROMPT_MESSAGE")];
		
		self.deletePlanPrompt = [[[UIAlertView alloc] initWithTitle:
				LOCALIZED_STR(@"DELETE_PLAN_PROMPT_TITLE")
					message:LOCALIZED_STR(@"DELETE_PLAN_PROMPT_MSG")
			delegate:self cancelButtonTitle:LOCALIZED_STR(@"CANCEL_PLAN_DELETE_BUTTON_TITLE")
				otherButtonTitles:LOCALIZED_STR(@"CONFIRM_PLAN_DELETE_BUTTON_TITLE"), nil] autorelease];
		self.deletePlanPrompt.alertViewStyle = UIAlertViewStyleDefault;
    }
    return self;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager]
			URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


-(void)populatePlanListFromDocDirectory
{	
    NSArray *directoryContent = [[NSFileManager defaultManager]
		contentsOfDirectoryAtURL:[self applicationDocumentsDirectory]
		includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
		options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
		
	self.planNameList = [[[NSMutableArray alloc] init] autorelease];
	for(NSString *fullyQualifiedDocName in directoryContent)
	{
		NSString *localDocName = [fullyQualifiedDocName lastPathComponent];
		if ([[localDocName pathExtension] isEqualToString:PLAN_DATA_FILE_EXTENSION])
		{
			[self.planNameList addObject:[localDocName stringByDeletingPathExtension]];
		}
	}
}

- (void)setTitle:(NSString *)title
{
	[super setTitle:title];
	[UIHelper setCommonTitleForController:self withTitle:title];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self populatePlanListFromDocDirectory];
	
	self.title = LOCALIZED_STR(@"PLAN_LIST_TITLE");
	
	self.tableView.tableHeaderView = [[[TableHeaderWithHelpFlipView alloc]
		initWithHeader:LOCALIZED_STR(@"PLAN_LIST_TABLE_TITLE")
		andSubHeader:LOCALIZED_STR(@"PLAN_LIST_TABLE_SUBTITLE") andHelpFile:@"planList"
		andAnchorWithinHelpFile:nil andParentController:self] autorelease];

	self.addButton = [[[UIBarButtonItem alloc]   
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd   
                                  target:self   
                                  action:@selector(addNewPlan)] autorelease];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.tableView.allowsSelectionDuringEditing = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.planNameList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
		[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil ] autorelease];
			
    // Configure the cell...
	
	NSString *planName = [self.planNameList objectAtIndex:indexPath.row];
	cell.textLabel.text = planName;
	cell.textLabel.font=[UIFont systemFontOfSize:16.0];
	
	NSString *currentPlanName = [AppHelper currentPlanName];
	
	if([planName isEqualToString:currentPlanName])
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		self.currentPlanPath = indexPath;
	}
	else
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}	
	cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    return cell;
}


- (void)addNewPlan
{
	UITextField *planNameTextField = [self.addPlanPrompt textFieldAtIndex:0];
	planNameTextField.text = @""; // clear out any previous plan name
	
	[self.addPlanPrompt show];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
	[self.navigationItem setHidesBackButton:editing animated:NO];
	
	if(!editing)
	{
		self.navigationItem.leftBarButtonItem = nil;
	}
	else
	{
		self.navigationItem.leftBarButtonItem = self.addButton; 			
	}	

 }



- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 32.0;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
	NSString *planName = [self.planNameList objectAtIndex:indexPath.row];
	if([planName isEqualToString:[AppHelper currentPlanName]])
	{
		return FALSE;
	}
	else
	{
		return TRUE;
	}
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
	
		self.planBeingDeleted = [self.planNameList objectAtIndex:indexPath.row];
		[self.deletePlanPrompt show];
     }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	NSString *planName = [self.planNameList objectAtIndex:indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

	if(self.editing)
	{
		if(![[AppHelper currentPlanName] isEqualToString:planName])
		{
			// Don't support renaming the currently selected/opened plan
			UITextField *planNameTextField = [self.renamePlanPrompt textFieldAtIndex:0];
			self.planBeingRenamed = planName;;
			planNameTextField.text = self.planBeingRenamed;
			[self.renamePlanPrompt show];
		}

	}
	else
	{
		if(self.currentPlanPath != nil)
		{
			UITableViewCell *checkedCell = [self.tableView cellForRowAtIndexPath:self.currentPlanPath];
			assert(checkedCell!=nil);
			checkedCell.accessoryType = UITableViewCellAccessoryNone;
		}
		NSLog(@"Selecting plan: %@",planName);
		[[AppHelper theAppDelegate] changeCurrentPlan:planName];
		self.currentPlanPath = indexPath;
		UITableViewCell *checkedCell = [self.tableView cellForRowAtIndexPath:self.currentPlanPath];
		assert(checkedCell!=nil);
		checkedCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
	editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return UITableViewCellEditingStyleDelete;
}

-(NSString*)sanitizeFileName:(NSString*)enteredFileName
{
	NSString *sanitizedFileName = [[enteredFileName componentsSeparatedByCharactersInSet:
			[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
			
    sanitizedFileName = [[sanitizedFileName componentsSeparatedByCharactersInSet:
			[NSCharacterSet illegalCharacterSet]] componentsJoinedByString:@"" ];
			
    sanitizedFileName = [[sanitizedFileName componentsSeparatedByCharactersInSet:
			[NSCharacterSet symbolCharacterSet]] componentsJoinedByString:@"" ];
	
	sanitizedFileName = [[sanitizedFileName componentsSeparatedByCharactersInSet:
			[NSCharacterSet characterSetWithCharactersInString:@"?*/\\:"]] componentsJoinedByString:@"" ];
				
	// Strip any whitespace from the begining and end of the string
    sanitizedFileName = [sanitizedFileName
		stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			
	return sanitizedFileName;

}

-(NSURL*)planFileURLFromPlanName:(NSString*)planName
{
	NSString *planFileWithExtension = [NSString stringWithFormat:@"%@.%@",planName,PLAN_DATA_FILE_EXTENSION];
	NSURL *planFileURL = [[self applicationDocumentsDirectory] 
			URLByAppendingPathComponent:planFileWithExtension];
				
	return planFileURL;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {
		
		if(alertView == self.renamePlanPrompt)
		{
			UITextField *fileNameField = [alertView textFieldAtIndex:0];
			NSString *sanitizedPlanName = [self sanitizeFileName:fileNameField.text];
			NSURL *planFileURL = [self planFileURLFromPlanName:sanitizedPlanName];

			NSURL *oldPlanURL = [self planFileURLFromPlanName:self.planBeingRenamed];
			if([[NSFileManager defaultManager] moveItemAtURL:oldPlanURL toURL:planFileURL error:nil])
			{
				[self populatePlanListFromDocDirectory];
				[self.tableView reloadData];
			}
		
		}
		else if(alertView == self.addPlanPrompt)
		{
			UITextField *fileNameField = [alertView textFieldAtIndex:0];
			NSString *sanitizedPlanName = [self sanitizeFileName:fileNameField.text];

			NSLog(@"Creating new plan for: %@", sanitizedPlanName);
			[AppHelper openPlanForPlanName:sanitizedPlanName];
			[self populatePlanListFromDocDirectory];
			[self.tableView reloadData];
		}
		
		else if(alertView == self.deletePlanPrompt)
		{
			NSURL *planToDeleteURL = [self planFileURLFromPlanName:self.planBeingDeleted];
			if([[NSFileManager defaultManager] removeItemAtURL:planToDeleteURL error:nil])
			{
				[self populatePlanListFromDocDirectory];
				[self.tableView reloadData];
			}
		}
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
	
	if(alertView == self.deletePlanPrompt)
	{
		return TRUE;
	}

	else if(alertView == self.renamePlanPrompt)
	{
		UITextField *fileNameField = [alertView textFieldAtIndex:0];
		NSString *sanitizedPlanName = [self sanitizeFileName:fileNameField.text];	
		NSURL *planFileURL = [self planFileURLFromPlanName:sanitizedPlanName];
		
		if(sanitizedPlanName.length == 0)
		{
			return FALSE;
		}
		
		else if([self.planBeingRenamed isEqualToString:sanitizedPlanName])
		{
			// No need to rename if the file name is the same as the one being edited.
			return FALSE;
		}
		
		else if([[NSFileManager defaultManager] fileExistsAtPath:[planFileURL path]])
		{
			// Another file already exists - don't allow editing
			return FALSE;
		}
		else
		{
			return TRUE;
		}
	}
	else if(alertView == self.addPlanPrompt)
	{
		UITextField *fileNameField = [alertView textFieldAtIndex:0];
		NSString *sanitizedPlanName = [self sanitizeFileName:fileNameField.text];	
		NSURL *planFileURL = [self planFileURLFromPlanName:sanitizedPlanName];

		if(sanitizedPlanName.length == 0)
		{
			return FALSE;
		}
		else if([[NSFileManager defaultManager] fileExistsAtPath:[planFileURL path]])
		{
			return FALSE;
		}
		else
		{
			return TRUE;
		}
	}

	return FALSE;
}

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range 
	replacementString:(NSString *)string 
{
    NSUInteger newLength = [theTextField.text length] + [string length] - range.length;
    return (newLength > MAX_PLAN_NAME_LENGTH) ? NO : YES;
}


@end
